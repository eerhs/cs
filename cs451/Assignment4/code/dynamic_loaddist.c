#include <stdio.h>
#include <mpi.h>

#define v 1 /* verbose flag, output if 1,
                          no output if 0 */
#define tag 100 /* tag for send and recv */

int manager ( int p, int n );
/*
 * The manager distributes n jobs 
 * among p processors and prints
 * the received results. */

int worker ( int i );
/*
 * Code for the i-th worker. */

int main ( int argc, char *argv[] )
{
   int i,p;

   MPI_Init(&argc,&argv);
   MPI_Comm_size(MPI_COMM_WORLD,&p);
   MPI_Comm_rank(MPI_COMM_WORLD,&i);

   if(i != 0)
      worker(i);
   if(i == 0)
   {
      printf("reading the #jobs per compute node...\n");
      int nbjobs; scanf("%d",&nbjobs);
      manager(p,nbjobs*(p-1));
   }

   MPI_Finalize();

   return 0;
}

int manager ( int p, int n )
{
   char result[n+1];
   int j;

   for(j=1; j<p; j++) /* distribute first jobs */
   {
      if(v == 1) printf("sending %d to %d\n",j-1,j);
      MPI_Send(&j,1,MPI_INT,j,tag,MPI_COMM_WORLD);
   }
   int done = 0;
   int nextjob = p-1;
   do                 /* probe for results */
   {
      int flag;
      MPI_Status status;
      MPI_Iprobe(MPI_ANY_SOURCE,MPI_ANY_TAG,
                 MPI_COMM_WORLD,&flag,&status);
      if(flag == 1)
      {              /* collect result */
         char c;
         j = status.MPI_SOURCE;
         if(v == 1) printf("received message from %d\n",j);
         MPI_Recv(&c,1,MPI_CHAR,j,tag,MPI_COMM_WORLD,&status);
         if(v == 1) printf("received %c from %d\n",c,j);
         result[done++] = c;
         if(v == 1) printf("#jobs done : %d\n",done);
         if(nextjob < n) /* send the next job */
         {
            if(v == 1) printf("sending %d to %d\n",nextjob,j);
            MPI_Send(&nextjob,1,MPI_INT,j,tag,MPI_COMM_WORLD);
            nextjob = nextjob + 1;
         }
         else  /* send -1 to signal termination */
         {
            if(v == 1) printf("sending -1 to %d\n",j);
            flag = -1;
            MPI_Send(&flag,1,MPI_INT,j,tag,MPI_COMM_WORLD);
         }
      }
   } while (done < n);
   result[done] = '\0';
   printf("The result : %s\n",result);
   return 0;
}
      
int worker ( int i )
{
   int myjob;
   MPI_Status status;

   do
   {
      MPI_Recv(&myjob,1,MPI_INT,0,tag,MPI_COMM_WORLD,&status);
      if(v == 1) printf("node %d received %d\n",i,myjob);
      if(myjob == -1) break;
      char c = 'a' + ((char)i);
      if(v == 1) printf("-> %d computes %c\n",i,c);
      if(v == 1) printf("node %d sends %c\n",i,c);
      MPI_Send(&c,1,MPI_CHAR,0,tag,MPI_COMM_WORLD);
   }
   while(myjob != -1);

   return 0;
}