#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
int main(void)
{
    int fd = open("/dev/uio0", O_RDWR);
    if (fd < 0) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    while (1) { /* some condition here */
        uint32_t info = 1; /* unmask */

        ssize_t nb = write(fd, &info, sizeof(info));
        if (nb < sizeof(info)) {
            perror("write");
            close(fd);
            exit(EXIT_FAILURE);
        }

        /* Wait for interrupt */
        nb = read(fd, &info, sizeof(info));
        if (nb == sizeof(info)) {
            /* Do something in response to the interrupt. */
            printf("Interrupt #%u!\n", info);
        }
    }

    close(fd);
    exit(EXIT_SUCCESS);
}