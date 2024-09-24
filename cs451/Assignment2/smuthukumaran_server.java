// Shree Ramachandran Muthukumaran
// smuthukumaran@hawk.iit.edu
// A20507651

import java.io.*;
import java.net.*;
import java.util.*;

public class smuthukumaran_server {
    private static final int PORT = 12345;
    private static List<String> words = new ArrayList<>();
    
    public static void main(String[] args) throws IOException {
        // Load words from a file
        loadWords("words.txt");
        
        // Create a server socket
        ServerSocket serverSocket = new ServerSocket(PORT);
        System.out.println("Hangman Server is running...");

        // Continuously listen for clients
        while (true) {
            Socket clientSocket = serverSocket.accept();
            System.out.println("New client connected!");
            
            // Handle each client in a new thread
            new Thread(new ClientHandler(clientSocket)).start();
        }
    }

    // Load words from a file into the words list
    private static void loadWords(String fileName) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(fileName))) {
            String word;
            while ((word = br.readLine()) != null) {
                words.add(word.trim());
            }
        }
    }

    private static class ClientHandler implements Runnable {
        private Socket clientSocket;
        private PrintWriter out;
        private BufferedReader in;
        private String wordToGuess;
        private char[] currentGuess;
        private Set<Character> guessedLetters;
        private int lives;

        public ClientHandler(Socket socket) throws IOException {
            this.clientSocket = socket;
            this.out = new PrintWriter(clientSocket.getOutputStream(), true);
            this.in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            this.lives = 10;
            this.guessedLetters = new HashSet<>();
            this.wordToGuess = getRandomWord();
            this.currentGuess = new char[wordToGuess.length()];
            Arrays.fill(this.currentGuess, '-');
        }

        @Override
        public void run() {
            try {
                sendInitialState();

                // Game loop
                while (lives > 0 && new String(currentGuess).contains("-")) {
                    String guess = in.readLine().trim().toLowerCase();
                    
                    if (isValidInput(guess)) {
                        char guessedChar = guess.charAt(0);
                        
                        if (guessedLetters.contains(guessedChar)) {
                            out.println("You already guessed '" + guessedChar + "'");
                        } else {
                            guessedLetters.add(guessedChar);
                            if (wordToGuess.contains(String.valueOf(guessedChar))) {
                                updateCurrentGuess(guessedChar);
                            } else {
                                lives--;
                            }
                        }
                    } else {
                        out.println("Invalid input. Please enter a single letter.");
                    }

                    sendGameState();
                }

                if (lives == 0) {
                    out.println("Sorry, you have used up all 10 lives. The correct word was '" + wordToGuess + "'");
                } else {
                    out.println("Congratulations! The correct word was '" + wordToGuess + "'");
                }
                out.println("Want to play again? (yes/no)");
            } catch (IOException e) {
                System.out.println("Error handling client: " + e.getMessage());
            } finally {
                try {
                    clientSocket.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        private void sendInitialState() {
            out.println(String.valueOf(currentGuess) + "   You have " + lives + " lives left.");
        }

        private void sendGameState() {
            out.println(String.valueOf(currentGuess) + "   You have " + lives + " lives left.");
        }

        private boolean isValidInput(String input) {
            return input.length() == 1 && Character.isLetter(input.charAt(0));
        }

        private void updateCurrentGuess(char guessedChar) {
            for (int i = 0; i < wordToGuess.length(); i++) {
                if (wordToGuess.charAt(i) == guessedChar) {
                    currentGuess[i] = guessedChar;
                }
            }
        }

        private String getRandomWord() {
            Random random = new Random();
            return words.get(random.nextInt(words.size()));
        }
    }
}