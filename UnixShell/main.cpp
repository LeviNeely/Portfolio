#include <iostream>
#include <readline/readline.h>
#include "shelpers.hpp"

using namespace std;

int main() {
    static char *line_read = (char *)NULL;
    //Wait for input
    while ((line_read = readline(""))) {
        //Tokenize input
        vector<string> arguments = tokenize(line_read);
        //Get all the commands
        vector<Command> commands = getCommands(arguments);
        //Changing directories if command is "cd"
        if (commands[0].exec == "cd") {
            //If the argument is a nullptr (no argument in the input)
            if (commands[0].argv[1] == nullptr) {
                //Send it to the home directory
                char *homeDirectory;
                homeDirectory = getenv("HOME");
                if (chdir(homeDirectory) < 0) {
                    perror("chdir error");
                    continue;
                }
            }
            //Otherwise just send it to where it is requesting to go
            else {
                if (chdir(commands[0].argv[1]) < 0) {
                    perror("chdir error");
                    continue;
                }
            }
            continue;
        }
        //Handle each command
        for (Command command : commands) {
            //If the command is to exit, then exit
            if (command.exec == "exit") {
                exit(0);
            }
            //Handle all other commands
            else {
                //Fork a new process
                pid_t newProcess = fork();
                if (newProcess < 0) {
                    perror("fork error");
                    continue;
                }
                //This is the parent
                else if (newProcess != 0) {
                    //Close the fdStdin if it has changed
                    if (command.fdStdin != STDIN_FILENO) {
                        if (close(command.fdStdin) < 0) {
                            perror("Closing fdStdin error");
                            continue;
                        }
                    }
                    //Close the fdStdout if it has changed
                    if (command.fdStdout != STDOUT_FILENO) {
                        if (close(command.fdStdout) < 0) {
                            perror("Closing fdStdin error");
                            continue;
                        }
                    }
                }
                //This is the child
                else if (newProcess == 0) {
                    //Dup2 the fdStdin if it has changed
                    if (command.fdStdin != STDIN_FILENO) {
                        if (dup2(command.fdStdin, 0) < 0) {
                            perror("fdStdin dup2 error");
                            continue;
                        }
                    }
                    //Dup2 the fdStdin if it has changed
                    if (command.fdStdout != STDOUT_FILENO) {
                        if (dup2(command.fdStdout, 1) < 0) {
                            perror("fdStdout dup2 error");
                            continue;
                        }
                    }
                    //Execute the command with the arguments passed
                    if (execvp(command.exec.c_str(), const_cast<char *const *>(command.argv.data())) < 0) {
                        perror("execvp error");
                        continue;
                    }
                }
                //Back to the parent, wait for the child to complete its function
                if (newProcess != 0) {
                    int childStatus;
                    if (pid_t waitChildPid = waitpid(newProcess, &childStatus, 0) == -1) {
                        perror("wait error");
                        continue;
                    }
                }
            }
        }
        //This just frees up the memory that the line being read is holding
        free (line_read);
    }
    return 0;
}
