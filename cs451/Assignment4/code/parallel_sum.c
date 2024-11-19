#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define v 1 /* verbose flag, output if 1, no output if 0 */

int main(int argc, char *argv[]) {
   int myid, p, n = 200;
   int *data = NULL;
   int *tosum;
   int start_index, end_index, num_elements;
   int local_sum = 0, global_sum;

   MPI_Init(&argc, &argv);
   MPI_Comm_rank(MPI_COMM_WORLD, &myid);
   MPI_Comm_size(MPI_COMM_WORLD, &p);

   /* Compute how to distribute the elements */
   int base_elements = n / p;  // number of elements per processor
   int remainder = n % p;      // remainder to distribute

   if (myid < remainder) {
      num_elements = base_elements + 1;
      start_index = myid * num_elements;
   } else {
      num_elements = base_elements;
      start_index = myid * num_elements + remainder;
   }
   end_index = start_index + num_elements;

   tosum = (int*)malloc(num_elements * sizeof(int));

   if (myid == 0) { /* manager allocates and initializes the data */
      data = (int*)calloc(n, sizeof(int));
      for (int j = 0; j < n; j++) data[j] = j + 1;
      if (v > 0) {
         printf("The data to sum: ");
         for (int j = 0; j < n; j++) printf(" %d", data[j]);
         printf("\n");
      }
   }

   /* Scatter data manually to each process */
   if (myid == 0) {
      for (int i = 1; i < p; i++) {
         int send_count = (i < remainder) ? base_elements + 1 : base_elements;
         int send_offset = (i < remainder) ? i * send_count : i * send_count + remainder;
         MPI_Send(&data[send_offset], send_count, MPI_INT, i, 0, MPI_COMM_WORLD);
      }
      /* Copy data for the master process */
      for (int j = 0; j < num_elements; j++) {
         tosum[j] = data[j];
      }
   } else {
      MPI_Recv(tosum, num_elements, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
   }

   /* Each process computes its local sum */
   for (int j = 0; j < num_elements; j++) {
      local_sum += tosum[j];
   }

   if (v > 0) {
      printf("Node %d has numbers to sum:", myid);
      for (int j = 0; j < num_elements; j++) printf(" %d", tosum[j]);
      printf("\nNode %d computes the sum %d\n", myid, local_sum);
   }

   /* Use MPI_Reduce to sum up all local sums into the global sum */
   MPI_Reduce(&local_sum, &global_sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

   if (myid == 0) {
      printf("The total sum is %d, which should be 20100.\n", global_sum);
   }

   /* Free allocated memory */
   free(tosum);
   if (myid == 0) free(data);
   
   MPI_Finalize();
   return 0;
}