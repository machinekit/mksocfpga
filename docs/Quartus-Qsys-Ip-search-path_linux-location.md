Update (6-mar-2016)

Backup and then delete this file:

    /home/<usrename>/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx 

or:

    ~/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx

In the quartus folder place an .ipx file with a relative path to the ip cores folder ie:

https://github.com/the-snowwhite/mksocfpga/blob/master/HW/QuartusProjects/DE0_Nano_SoC_Cramps/soc_system.ipx

    cd <project folder>
    
    cat <<EOT > ./soc_system.ipx
    <?xml version="1.0" encoding="UTF-8"?>
    <library>
     <path path="../../ip/**/*" />
    </library>
    EOT    

---

This is a reference to the Global Quartus IP core search path, not excatly the one qsys uses...!

/home/mib/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx 

Containing:

<?xml version="1.0" encoding="UTF-8"?>
<library>
 <path path="/home/mib/Developer/the-snowwhite_git/mksocfpga/HW/ip/**/*" />
</library>


Linux Quartus 15.1(Installed in standard location) Relocation Fix:

(path is relative to quartus project folder)

Change path to relative path instead:


    mib@debian9-ws:~$ cat /home/mib/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx 
    <?xml version="1.0" encoding="UTF-8"?>
    <library>
     <path path="../../ip/**/*" />
    </library>

    mib@debian9-ws:~$ cat ~/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx 
    <?xml version="1.0" encoding="UTF-8"?>
    <library>
     <path path="../../ip/**/*" />
    </library>
    mib@debian9-ws:~$ 

do:

    cat <<EOT > ~/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx
     <?xml version="1.0" encoding="UTF-8"?>
    <library>
     <path path="../../ip/**/*" />
    </library>
    EOT

    