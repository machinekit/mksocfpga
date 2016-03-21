#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

#include <linux/device.h>
#include <linux/platform_device.h>
#include <linux/uaccess.h>
#include <linux/ioport.h>
#include <linux/io.h>

#define adcreg_BASE 0xff250000

//#define PRINT_INFO

void *adcreg_mem;

static struct device_driver adcreg_driver = {
	.name = "adcreg",
	.bus = &platform_bus_type,
};


static ssize_t adcreg_show(struct device_driver *drv, char *buf)
{
 	u16 bufindex, data_size, length,file_length, count;
	u16 indata, sample_count, s_ch;
	u16 measure_fifo_done;

	indata =  ioread16(adcreg_mem);
	measure_fifo_done = (indata & 0x0001);
	sample_count = ((indata >> 1) & 0x0FFF);
	s_ch = ((indata >> 13) & 0x0007);
#ifdef PRINT_INFO
	printk("\n \nadcreg_show_1: status = %u\ts_ch = %u\tsample_count = %u\n",measure_fifo_done,s_ch,sample_count);
#endif

	data_size = sizeof(indata);

#ifdef PRINT_INFO
	printk("\nadcreg_show_2: initial buf width = %u bytes\t mem pointer width = %u\n", data_size, sizeof(adcreg_mem));
#endif
	if(measure_fifo_done){
	    length = (sample_count * data_size);
	    file_length = length + data_size;
#ifdef PRINT_INFO
	    printk("\nadcreg_show_3: length = %u\n", length);
#endif
	    buf[0] = (indata & 0xFF); buf[1] = (indata >> 8);
	    count = 0;
	    for (bufindex=data_size;bufindex < file_length;bufindex=bufindex+data_size)
	    {
                indata =  ioread16(adcreg_mem + 4);
		buf[bufindex] = (indata & 0xFF); buf[bufindex+1] = (indata >> 8); count++;
#ifdef PRINT_INFO
		printk("\nWrote to bufindex --> %u \t Databyte  = 0x%04x \n \n", bufindex, indata);
#endif
	    }

#ifdef PRINT_INFO
	    printk("\nadcreg_show_4: wrote %u samples\n",count);
#endif
#ifdef PRINT_INFO
	    for (bufindex=0;bufindex < file_length;bufindex=bufindex+data_size)
	    {
		printk("\nData_index --> %u \t Highbyte, Lowbyte  = 0x%02x%02x \n \n", (bufindex >> 1), buf[bufindex+1], buf[bufindex]);
	    }
#endif
	}
	else {
	  buf[0] = (indata & 0xFF); buf[1] = (indata >> 8);
	  file_length = data_size;
	}
	return file_length;
}

static ssize_t adcreg_store(struct device_driver *drv, const char *buf, size_t count)
{
	u16 setadr, setdata;

	if (buf == NULL) {
		pr_err("Error, string must not be NULL\n");
		return -EINVAL;
	}
#ifdef PRINT_INFO
	printk("adcreg_store:  Data reveived by adcreg count = %u \n", count);
#endif
//	setadr = buf[0] + (buf[1] << 8);
	setadr = (buf[0] & 0x07);
	setdata = (buf[2] + (buf[3] << 8));

#ifdef PRINT_INFO
	printk("\nAddress %u\t will be written with %u  0x%04x  \n", setadr, setdata, setdata);
#endif
	iowrite16(setdata, adcreg_mem + setadr);
	return count;
}

static DRIVER_ATTR(adcreg , (S_IWUSR | S_IRUSR | S_IRGRP | S_IWGRP |  S_IROTH | S_IWOTH), adcreg_show, adcreg_store);

MODULE_AUTHOR("Michael Brown");
MODULE_DESCRIPTION("Terasic adc_ltc2308_fifo ip core driver developed for Machinekit use");
MODULE_LICENSE("GPL v2");
//MODULE_ALIAS("platform:" DRIVER_NAME);

static int __init adcreg_init(void)
{
	int ret;
	struct resource *res;

	ret = driver_register(&adcreg_driver);
	if (ret < 0)
		return ret;

	ret = driver_create_file(&adcreg_driver, &driver_attr_adcreg);
	if (ret < 0) {
		driver_unregister(&adcreg_driver);
		return ret;
	}

        res = request_mem_region(adcreg_BASE, PAGE_SIZE, "adcreg");
	if (res == NULL) {
		driver_remove_file(&adcreg_driver, &driver_attr_adcreg);
		driver_unregister(&adcreg_driver);
		return -EBUSY;
	}

	adcreg_mem = ioremap(adcreg_BASE , PAGE_SIZE);
	if (adcreg_mem == NULL) {
		driver_remove_file(&adcreg_driver, &driver_attr_adcreg);
		driver_unregister(&adcreg_driver);
		release_mem_region(adcreg_BASE, PAGE_SIZE);
		return -EFAULT;
	}

	return 0;
}

static void __exit adcreg_exit(void)
{
	driver_remove_file(&adcreg_driver, &driver_attr_adcreg);
	driver_unregister(&adcreg_driver);
	release_mem_region(adcreg_BASE, PAGE_SIZE);
	iounmap(adcreg_mem);
}

module_init(adcreg_init);
module_exit(adcreg_exit);

MODULE_LICENSE("Dual BSD/GPL");
