Qsys complaining about ip core not found, can be solved by adding a relative(to project folder) path
to the (custom) ip cores:

The qsys ip search path is now solved
by placing the soc_system.ipx (a .ipx) file in the project folder containing:


    <?xml version="1.0" encoding="UTF-8"?>
    <library>
     <path path="../../ip/**/*" />
    </library>

----

This is about the Quartus gui Global ip library search path:

Resides in file:
~/.altera.quartus/ip/15.1/ip_search_path/user_components.ipx

Contents example:

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

