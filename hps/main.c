#define soc_cv_av
#include <time.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"

#define HPS_FPGA_BRIDGE_BASE (0xC0000000)
#define HW_REGS_BASE (HPS_FPGA_BRIDGE_BASE)
#define HW_REGS_SPAN (0x40000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

//The address of peripheral is the HPS-FPGA bridge + Qsys address assigned to it
#define FPGA_QSYS_ADDRESS 0x0
#define FPGA_ADDRESS ((uint8_t *)0xC0000000 + FPGA_QSYS_ADDRESS)

int main()
{

	void *virtual_base;
	int fd;
	void *h2p_reg_addr[5];
	int i;

	// map the address space for the registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span
	if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
	{
		printf("ERROR: could not open \"/dev/mem\"...\n");
		return (1);
	}

	virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

	if (virtual_base == MAP_FAILED)
	{
		printf("ERROR: mmap() failed...\n");
		close(fd);
		return (1);
	}

	for (i = 0; i < 5; i++)
	{
		h2p_reg_addr[i] = virtual_base + (((unsigned long)(FPGA_ADDRESS) + (unsigned long)(4 * i)) & (unsigned long)(HW_REGS_MASK));
	}

	// PROGRAM
	int reg_content;
	int switch_state;
	int switch_mask = 0x3;
	double t_period;
	clock_t last_rec_time;
	int led_status = 0;
	double t_dif;

	for (i = 0; i < 5; i++)
	{
		reg_content = *(uint32_t *)h2p_reg_addr[i];
		printf("Register %d has stored: %d. What should the new value be? \t", i, reg_content);
		scanf("%d", &reg_content);
		*(uint32_t *)h2p_reg_addr[i] = reg_content;
		reg_content = *(uint32_t *)h2p_reg_addr[i];
		printf("The value saved in register %d has been changed to: %d\n\n", i, reg_content);
	}
	i = 0;

	for (i = 0; i < 1000; i++)
	{
		reg_content = *(uint32_t *)h2p_reg_addr[4];		 //Read the 4th register
		printf("IO-Register has stored: %d\n", reg_content);
		switch_state = (int)(reg_content & switch_mask); //Logic AND so as to only keep the last 2 bits (switches)
		printf("The switch_state is: %d\n", switch_state);
		switch (switch_state)
		{
		case 0:
			t_period = -1;
			*(uint32_t *)h2p_reg_addr[4] = (unsigned long)(0); // Always off
			printf("LED is supposed to be OFF\n");
			break;
		case 1:
			t_period = -1;
			*(uint32_t *)h2p_reg_addr[4] = (unsigned long)(4); // Always on -> 4 = 100
			printf("LED is supposed to be ON\n");
			break;
		case 2:
			t_period = 0.5;
			printf("LED is supposed to be changing\n");
			break;
		case 3:
			t_period = 0.167;
			printf("LED is supposed to be changing\n");
			break;
		}

		t_dif = ((double)clock()-last_rec_time)/CLOCKS_PER_SEC; // time in seconds
		printf("%f\n",t_dif);

		if ((t_dif>t_period) && (t_period > 0))
		{							  //if time is up and it's supposed to blink
			led_status = !led_status; //toggle LED status
			*(uint32_t *)h2p_reg_addr[4] = (unsigned long)(led_status*4);
			last_rec_time = clock();
			i ++;
		}
	}
		// clean up our memory mapping and exit

	if (munmap(virtual_base, HW_REGS_SPAN) != 0)
	{
		printf("ERROR: munmap() failed...\n");
		close(fd);
		return (1);
	}

	close(fd);

	return (0);
}
