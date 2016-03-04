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

    