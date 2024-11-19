
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
   else
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
   int job = -1;
   int j;
   do
   {
      for(j=1; j<p; j++) /* distribute jobs */
      {
         if(++job >= n) break;
         int d = 1 + (job % (p-1));
         if(v == 1) printf("sending %d to %d\n",job,d);
         MPI_Send(&job,1,MPI_INT,d,tag,MPI_COMM_WORLD);
      }
      if(job >= n) break;
      for(j=1; j<p; j++) /* collect results */
      {  
         char c;
         MPI_Status status;
         MPI_Recv(&c,1,MPI_CHAR,j,tag,MPI_COMM_WORLD,&status);
         if(v == 1) printf("received %c from %d\n",c,j);
         result[job-p+1+j] = c;
      }
   } while (job < n);
   job = -1;
   for(j=1; j < p; j++)  /* termination signal is -1 */
   {
      if(v==1) printf("sending -1 to %d\n",j);
      MPI_Send(&job,1,MPI_INT,j,tag,MPI_COMM_WORLD);
   }
   result[n] = '\0';
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