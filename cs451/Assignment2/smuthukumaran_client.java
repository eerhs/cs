// Shree Ramachandran Muthukumaran
// smuthukumaran@hawk.iit.edu
// A20507651

import java.io.*;
import java.net.*;

public class smuthukumaran_client {
    private static final String SERVER_ADDRESS = "18.222.184.212"; //make sure the address is of the server 
    private static final int SERVER_PORT = 12345; //match ports with the server

    public static void main(String[] args) {
        try (Socket socket = new Socket(SERVER_ADDRESS, SERVER_PORT);
             BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
             PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
             BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in))) {

            String serverResponse;
            while ((serverResponse = in.readLine()) != null) {
                System.out.println(serverResponse);

                if (serverResponse.startsWith("Congratulations") || serverResponse.startsWith("Sorry")) {
                    System.out.print("Do you want to play again? (yes/no): ");
                    String playAgain = userInput.readLine().trim();
                    out.println(playAgain);
                    if ("no".equalsIgnoreCase(playAgain)) {
                        break;
                    }
                } else if (serverResponse.contains("-")) {
                    System.out.print("Enter your guess: ");
                    String guess = userInput.readLine().trim();
                    out.println(guess);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}