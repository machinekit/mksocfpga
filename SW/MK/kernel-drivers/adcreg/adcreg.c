#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

#include <linux/device.h>
#include <linux/platform_device.h>
#include <linux/uaccess.h>
#include <linux/ioport.h>
#include <linux/io.h>

#define adcreg_BASE 0xff250000
#define adcreg_SIZE 4096

//#define PRINT_INFO 

void *adcreg_mem;

static struct device_driver adcreg_driver = {
	.name = "adcreg",
	.bus = &platform_bus_type,
};

ssize_t adcreg_show(struct device_driver *drv, char *buf)
{
 	u16 bufindex, size, length;
	u16 indata, sample_count, s_ch;
	
	indata =  ioread16(adcreg_mem);
	sample_count = ((indata >> 1) & 0x0FFF)+1;
	s_ch = ((indata >> 13) & 0x0007);
#ifdef PRINT_INFO 	
	printk("\n \nadcreg_show_1: sample_count = %u\t s_ch = %u\n",sample_count,s_ch);
#endif
	
	size = sizeof(buf);

#ifdef PRINT_INFO 	
	printk("\nadcreg_show_2: initial buf width = %u bytes\n", size);
#endif
	length = (sample_count << 1); 

	buf[0] = (indata & 0xFF); buf[1] = (indata >> 8);

	for (bufindex=2;bufindex < length-1;bufindex=bufindex+2)
 	{
                indata =  ioread16(adcreg_mem + 4);
		buf[bufindex] = (indata & 0xFF); buf[bufindex+1] = (indata >> 8);
        }

#ifdef PRINT_INFO
        printk("\nadcreg_show_3: wrote %u bytes\n",length);
#endif
#ifdef PRINT_INFO
	for (bufindex=0;bufindex < length ;bufindex=bufindex+2)
        {
	    printk("\nAddress --> %u \t Highbyte, Lowbyte  = 0x%02x  0x%02x \n \n", (bufindex >> 1), buf[bufindex+1], buf[bufindex]);
	}
#endif
	return length;
}

ssize_t adcreg_store(struct device_driver *drv, const char *buf, size_t count)
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
	setadr = (buf[0] & 0x07);//   + (buf[1] << 8);
	setdata = ((buf[2] + (buf[3] << 8)) & 0x07FF);
	
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
        
        res = request_mem_region(adcreg_BASE, adcreg_SIZE, "adcreg");
	if (res == NULL) {
		driver_remove_file(&adcreg_driver, &driver_attr_adcreg);
		driver_unregister(&adcreg_driver);
		return -EBUSY;
	}

	adcreg_mem = ioremap(adcreg_BASE , adcreg_SIZE);
	if (adcreg_mem == NULL) {
		driver_remove_file(&adcreg_driver, &driver_attr_adcreg);
		driver_unregister(&adcreg_driver);
		release_mem_region(adcreg_BASE, adcreg_SIZE);
		return -EFAULT;
	}

	return 0;
}

static void __exit adcreg_exit(void)
{
	driver_remove_file(&adcreg_driver, &driver_attr_adcreg);
	driver_unregister(&adcreg_driver);
	release_mem_region(adcreg_BASE, adcreg_SIZE);
	iounmap(adcreg_mem);
}

module_init(adcreg_init);
module_exit(adcreg_exit);

MODULE_LICENSE("Dual BSD/GPL");
