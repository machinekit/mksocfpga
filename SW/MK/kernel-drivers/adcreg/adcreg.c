#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

#include <linux/device.h>
#include <linux/platform_device.h>
#include <linux/uaccess.h>
#include <linux/ioport.h>
#include <linux/io.h>

#define adcreg_BASE 0xff250000
#define adcreg_SIZE 32

//#define DRIVER_NAME "adcreg"

void *adcreg_mem;

static struct device_driver adcreg_driver = {
	.name = "adcreg",
	.bus = &platform_bus_type,
};

ssize_t adcreg_show(struct device_driver *drv, char *buf)
{
 	u16 bufindex, size;
	u16 indata, sample_count;
	
	indata =  ioread16(adcreg_mem);
	sample_count = (indata >> 1)+1;
	printk("\nadcreg_show: measure_count = %u\n",sample_count);
	
	size = sizeof(buf);
	
	printk("\nadcreg_show: initial buf size = %u bytes\n", size);
	size = (sample_count << 1); 
/*
	for (bufindex=0;bufindex < size;bufindex++)
        {
//	    kstrtou8(buf[adr], 10, &rawdata);
	    printk("bufindex --> %u\t bufdata = %u\n", bufindex, buf[bufindex]);
	}
*/	
	buf[0] = (indata & 0xFF); buf[1] = (indata >> 8);
	for (bufindex=2;bufindex < size-1;bufindex=bufindex+2)
 	{
                indata =  ioread16(adcreg_mem + 4);
		buf[bufindex] = (indata & 0xFF); buf[bufindex+1] = (indata >> 8);
        }

        printk("adcreg_show: deliverd %u bytes\n",sizeof(buf));

	for (bufindex=0;bufindex < (size >> 1);bufindex=bufindex+2)
        {
	    printk("bufindex --> %u-1 , 2 \t bufdata = %04x  %04x \n", bufindex, buf[bufindex], buf[bufindex+1]);
	}

	return size;
}

ssize_t adcreg_store(struct device_driver *drv, const char *buf, size_t count)
{
	u16 setadr, setdata;

	if (buf == NULL) {
		pr_err("Error, string must not be NULL\n");
		return -EINVAL;
	}

	printk("adcreg_store:  Data reveived by adcreg count = %u \n", count);

	setadr = buf[0] + (buf[1] << 8);
	setdata = buf[2] + (buf[3] << 8);
	
	printk("\nAddress %u\t will be written with %u  0x%04x  \n", setadr, setdata, setdata);

	iowrite16(setdata, adcreg_mem + setadr);
	return count;
}

static DRIVER_ATTR(adcreg , (S_IWUSR | S_IRUSR | S_IRGRP | S_IWGRP |  S_IROTH | S_IWOTH), adcreg_show, adcreg_store);

//MODULE_AUTHOR("Michael Brown");
//MODULE_DESCRIPTION("Terasic adc_ltc2308_fifo ip core driver developed for Machinekit use");
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
