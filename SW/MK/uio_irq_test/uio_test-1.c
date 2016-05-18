#define _XOPEN_SOURCE 500

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

int main()
{
	int uiofd;
	int configfd;
	int err;
	int i;
	unsigned icount;
	unsigned char command_high;

	uiofd = open("/dev/uio0", O_RDONLY);
	if (uiofd < 0) {
		perror("uio open:");
		return errno;
	}
	configfd = open("/sys/class/uio/uio0/device/config", O_RDWR);
	if (configfd < 0) {
		perror("config open:");
		return errno;
	}

	/* Read and cache command value */
	err = pread(configfd, &command_high, 1, 5);
	if (err != 1) {
		perror("command config read:");
		return errno;
	}
	command_high &= ~0x4;

	for(i = 0;; ++i) {
		/* Print out a message, for debugging. */
		if (i == 0)
			fprintf(stderr, "Started uio test driver.\n");
		else
			fprintf(stderr, "Interrupts: %d\n", icount);

		/****************************************/
		/* Here we got an interrupt from the
		   device. Do something to it. */
		/****************************************/

		/* Re-enable interrupts. */
		err = pwrite(configfd, &command_high, 1, 5);
		if (err != 1) {
			perror("config write:");
			break;
		}

		/* Wait for next interrupt. */
		err = read(uiofd, &icount, 4);
		if (err != 4) {
			perror("uio read:");
			break;
		}

	}
	return errno;
}
