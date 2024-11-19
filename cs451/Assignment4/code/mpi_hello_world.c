#include <stdio.h>
#include <mpi.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int rank, size;
    char name[100]; // Buffer to store the name

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    if (rank == 0) {
        // prompt for name
        printf("Enter your name: ");
        fgets(name, 100, stdin);
        name[strcspn(name, "\n")] = 0; // Remove newline
    }

    // Broadcast the name from the manager node to all other nodes
    MPI_Bcast(name, 100, MPI_CHAR, 0, MPI_COMM_WORLD);

    printf("Processor %d out of %d salutes %s!\n", rank, size, name);

    MPI_Finalize();
    return 0;
}