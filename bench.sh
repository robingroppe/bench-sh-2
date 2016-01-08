#!/usr/bin/env bash
#####################################################################
# Benchmark Script 2 by Hidden Refuge from FreeVPS                  #
# Copyright(C) 2015 - Hidden Refuge                                 #
# License: GNU General Public License 3.0                           #
# Github: https://github.com/hidden-refuge/bench-sh-2               #
# More European Mirrors and Pingcheck added by Robin Groppe	    #
#####################################################################
# Original script by akamaras/camarg                                #
# Original: http://www.akamaras.com/linux/linux-server-info-script/ #
# Original Copyright (C) 2011 by akamaras/camarg                    #
#####################################################################
# The speed test was added by dmmcintyre3 from FreeVPS.us as a      #
# modification to the original script.                              #
# Modded Script: https://freevps.us/thread-2252.html                #
# Copyright (C) 2011 by dmmcintyre3 for the modification            #
#####################################################################
sysinfo () {
	# Removing existing bench.log
	rm -rf $HOME/bench.log
	# Reading out system information...
	# Reading CPU model
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading amount of CPU cores
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	# Reading CPU frequency in MHz
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading total memory in MB
	tram=$( free -m | awk 'NR==2 {print $2}' )
	# Reading Swap in MB
	vram=$( free -m | awk 'NR==4 {print $2}' )
	# Reading system uptime
	up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading operating system and version (simple, didn't filter the strings at the end...)
	opsy=$( cat /etc/issue.net | awk 'NR==1 {print}' ) # Operating System & Version
	arch=$( uname -m ) # Architecture
	lbit=$( getconf LONG_BIT ) # Architecture in Bit
	hn=$( hostname ) # Hostname
	kern=$( uname -r )
	# Date of benchmark
	bdates=$( date )
	echo "Benchmark started on $bdates" | tee -a $HOME/bench.log
	echo "Full benchmark log: $HOME/bench.log" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Output of results
	echo "System Info" | tee -a $HOME/bench.log
	echo "-----------" | tee -a $HOME/bench.log
	echo "Processor	: $cname" | tee -a $HOME/bench.log
	echo "CPU Cores	: $cores" | tee -a $HOME/bench.log
	echo "Frequency	: $freq MHz" | tee -a $HOME/bench.log
	echo "Memory		: $tram MB" | tee -a $HOME/bench.log
	echo "Swap		: $vram MB" | tee -a $HOME/bench.log
	echo "Uptime		: $up" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "OS		: $opsy" | tee -a $HOME/bench.log
	echo "Arch		: $arch ($lbit Bit)" | tee -a $HOME/bench.log
	echo "Kernel		: $kern" | tee -a $HOME/bench.log
	echo "Hostname	: $hn" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
speedtest4 () {
	ipiv=$( wget -qO- ipv4.icanhazip.com ) # Getting IPv4
	# Speed test via wget for IPv4 only with 10x 100 MB files. 1 GB bandwidth will be used!
	echo "Speedtest (IPv4 only)" | tee -a $HOME/bench.log
	echo "---------------------" | tee -a $HOME/bench.log
	echo "Your public IPv4 is $ipiv" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Cachefly CDN speed test
	echo "Location		Provider	Speed		Ping"	| tee -a $HOME/bench.log
	cachefly=$( wget -4 -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingcachefly=$( ping -c 5 cachefly.cachefly.net | awk -F '/' 'END {print $5}' )
	echo "CDN			Cachefly	$cachefly	$pingcachefly ms " | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# United States speed test
	coloatatl=$( wget -4 -O /dev/null http://speed.atl.coloat.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingcoloatl=$( ping -c 5 speed.atl.coloat.com | awk -F '/' 'END {print $5}' )
	echo "Atlanta, GA, US		Coloat		$coloatatl 	$pingcoloatl ms " | tee -a $HOME/bench.log
	sldltx=$( wget -4 -O /dev/null http://speedtest.dal05.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingsldltx=$( ping -c 5 speedtest.dal05.softlayer.com | awk -F '/' 'END {print $5}' )
	echo "Dallas, TX, US		Softlayer	$sldltx 	$pingsldltx ms " | tee -a $HOME/bench.log
	slwa=$( wget -4 -O /dev/null http://speedtest.sea01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingslwa=$( ping -c 5 speedtest.sea01.softlayer.com | awk -F '/' 'END {print $5}' )
	echo "Seattle, WA, US		Softlayer	$slwa 	$pingslwa ms " | tee -a $HOME/bench.log
	slsjc=$( wget -4 -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingslsjc=$( ping -c 5 speedtest.sjc01.softlayer.com | awk -F '/' 'END {print $5}' )
	echo "San Jose, CA, US	Softlayer	$slsjc	$pingslsjc ms " | tee -a $HOME/bench.log
	slwdc=$( wget -4 -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingslwdc=$( ping -c 5 speedtest.wdc01.softlayer.com | awk -F '/' 'END {print $5}' )
	echo "Washington, DC, US	Softlayer 	$slwdc	$pingslwdc ms " | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Asia speed test
	linodejp=$( wget -4 -O /dev/null http://speedtest.tokyo.linode.com/100MB-tokyo.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pinglinodejp=$( ping -c 5 speedtest.tokyo.linode.com | awk -F '/' 'END {print $5}' )
	echo "Tokyo, Japan		Linode		$linodejp 	$pinglinodejp ms " | tee -a $HOME/bench.log
	slsg=$( wget -4 -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingslsg=$( ping -c 5 speedtest.sng01.softlayer.com | awk -F '/' 'END {print $5}' )
	echo "Singapore 		Softlayer	$slsg	$pingslsg ms " | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Europe speed test
	i3d=$( wget -4 -O /dev/null http://mirror.i3d.net/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingi3d=$( ping -c 5 mirror.i3d.net | awk -F '/' 'END {print $5}' )
	echo "Rotterdam, Netherlands	id3.net		$i3d	$pingi3d ms " | tee -a $HOME/bench.log
	leaseweb=$( wget -4 -O /dev/null http://mirror.leaseweb.com/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingleaseweb=$( ping -c 5 mirror.leaseweb.com | awk -F '/' 'END {print $5}' )
	echo "Haarlem, Netherlands	Leaseweb	$leaseweb 	$pingleaseweb ms " | tee -a $HOME/bench.log
	ovh=$( wget -4 -O /dev/null http://ovh.net/files/100Mb.dat 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingovh=$( ping -c 5 mirror.ovh.net | awk -F '/' 'END {print $5}' ) #ovh.net not accepting ping
	echo "Strasbourg, France 	OVH		$ovh	$pingovh ms " | tee -a $HOME/bench.log
	hetzner=$( wget -4 -O /dev/null http://speed.hetzner.de/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pinghetzner=$( ping -c 5 speed.hetzner.de | awk -F '/' 'END {print $5}' )
	echo "Falkenstein, Germany 	Hetzner		$hetzner 	$pinghetzner ms " | tee -a $HOME/bench.log
	myloc=$( wget -4 -O /dev/null http://speed.myloc.de/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingmyloc=$( ping -c 5 speed.myloc.de | awk -F '/' 'END {print $5}' )
	echo "Duesseldorf, Germany 	MyLoc		$myloc	$pingmyloc ms " | tee -a $HOME/bench.log
	netcologne=$( wget -4 -O /dev/null http://speedtest.netcologne.de/test_100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	pingnetcologne=$( ping -c 5 speedtest.netcologne.de | awk -F '/' 'END {print $5}' )
	echo "Koeln, Germany 		NetCologne	$netcologne	$pingnetcologne ms " | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
speedtest6 () {
	ipvii=$( wget -qO- ipv6.icanhazip.com ) # Getting IPv6
  	# Speed test via wget for IPv6 only with 10x 100 MB files. 1 GB bandwidth will be used! No CDN - Cachefly not IPv6 ready...
  	echo "Speedtest (IPv6 only)" | tee -a $HOME/bench.log
  	echo "---------------------" | tee -a $HOME/bench.log
  	echo "Your public IPv6 is $ipvii" | tee -a $HOME/bench.log
  	echo "" | tee -a $HOME/bench.log
  	echo "Location		Provider	Speed" | tee -a $HOME/bench.log
  	# United States speed test
	v6atl=$( wget -6 -O /dev/null http://speedtest.atlanta.linode.com/100MB-atlanta.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Atlanta, GA, US		Linode		$v6atl" | tee -a $HOME/bench.log
  	v6dal=$( wget -6 -O /dev/null http://speedtest.dallas.linode.com/100MB-dallas.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	echo "Dallas, TX, US		Linode		$v6dal" | tee -a $HOME/bench.log
  	v6new=$( wget -6 -O /dev/null http://speedtest.newark.linode.com/100MB-newark.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	echo "Newark, NJ, US		Linode	 	$v6new" | tee -a $HOME/bench.log
	v6fre=$( wget -6 -O /dev/null http://speedtest.fremont.linode.com/100MB-fremont.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Fremont, CA, US		Linode	 	$v6fre" | tee -a $HOME/bench.log
  	v6chi=$( wget -6 -O /dev/null http://testfile.chi.steadfast.net/data.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	echo "Chicago, IL, US		Steadfast	$v6chi" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Asia speed test
  	v6tok=$( wget -6 -O /dev/null http://speedtest.tokyo.linode.com/100MB-tokyo.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	echo "Tokyo, Japan		Linode	 	$v6tok" | tee -a $HOME/bench.log
  	v6sin=$( wget -6 -O /dev/null http://speedtest.singapore.linode.com/100MB-singapore.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
  	echo "Singapore		Linode		$v6sin" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Europe speed test
	v6fra=$( wget -6 -O /dev/null http://speedtest.frankfurt.linode.com/100MB-frankfurt.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Frankfurt, Germany	Linode		$v6fra" | tee -a $HOME/bench.log
        v6lon=$( wget -6 -O /dev/null http://speedtest.london.linode.com/100MB-london.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "London, UK		Linode		$v6lon" | tee -a $HOME/bench.log
        v6har=$( wget -6 -O /dev/null http://mirror.nl.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        echo "Haarlem, Netherlands	Leaseweb	$v6har" | tee -a $HOME/bench.log
	v6ovh=$( wget -6 -O /dev/null http://ovh.net/files/100Mb.dat 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Strasbourg, France 	OVH		$v6ovh " | tee -a $HOME/bench.log
	v6hetzner=$( wget -6 -O /dev/null http://speed.hetzner.de/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Falkenstein, Germany 	Hetzner		$v6hetzner " | tee -a $HOME/bench.log
	v6myloc=$( wget -6 -O /dev/null http://speed.myloc.de/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Duesseldorf, Germany 	MyLoc		$v6myloc " | tee -a $HOME/bench.log
	v6netcologne=$( wget -6 -O /dev/null http://speed.myloc.de/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
	echo "Koeln, Germany 		NetCologne	$v6netcologne " | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
iotest () {
	echo "Disk Speed" | tee -a $HOME/bench.log
	echo "----------" | tee -a $HOME/bench.log
	# Measuring disk speed with DD
	io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Calculating avg I/O (better approach with awk for non int values)
	ioraw=$( echo $io | awk 'NR==1 {print $1}' )
	ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
	ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
	ioall=$( awk 'BEGIN{print '$ioraw' + '$ioraw2' + '$ioraw3'}' )
	ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
	# Output of DD result
	echo "I/O (1st run)	: $io" | tee -a $HOME/bench.log
	echo "I/O (2nd run)	: $io2" | tee -a $HOME/bench.log
	echo "I/O (3rd run)	: $io3" | tee -a $HOME/bench.log
	echo "Average I/O	: $ioavg MB/s" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
gbench () {
	# Improved version of my code by thirthy_speed https://freevps.us/thread-16943-post-191398.html#pid191398
	echo "" | tee -a $HOME/bench.log
	echo "System Benchmark (Experimental)" | tee -a $HOME/bench.log
	echo "-------------------------------" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Note: The benchmark might not always work (eg: missing dependencies)." | tee -a $HOME/bench.log
	echo "Failures are highly possible. We're using Geekbench for this test." | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
        gb_page=http://www.primatelabs.com/geekbench/download/linux/
        gb_dl=$(wget -qO - $gb_page | \
                 sed -n 's/.*\(https\?:[^:]*\.tar\.gz\).*/\1/p')
        gb_noext=${gb_dl##*/}
        gb_noext=${gb_noext%.tar.gz}
        gb_name=${gb_noext//-/ }
	echo "File is located at $gb_dl" | tee -a $HOME/bench.log
	echo "Downloading and extracting $gb_name" | tee -a $HOME/bench.log
        wget -qO - "$gb_dl" | tar xzv 2>&1 >/dev/null
	echo "" | tee -a $HOME/bench.log
	echo "Starting $gb_name" | tee -a $HOME/bench.log
	echo "The system benchmark may take a while." | tee -a $HOME/bench.log
	echo "Don't close your terminal/SSH session!" | tee -a $HOME/bench.log
	echo "All output is redirected into a result file." | tee -a $HOME/bench.log
	echo "" >> $HOME/bench.log
	echo "--- Geekbench Results ---" >> $HOME/bench.log
	sleep 2
	$HOME/dist/$gb_noext/geekbench_x86_32 >> $HOME/bench.log
	echo "--- Geekbench Results End ---" >> $HOME/bench.log
	echo "" >> $HOME/bench.log
	echo "Finished. Removing Geekbench files" | tee -a $HOME/bench.log
	sleep 1
	rm -rf $HOME/dist/
	echo "" | tee -a $HOME/bench.log
        gbl=$(sed -n '/following link/,/following link/ {/following link\|^$/b; p}' $HOME/bench.log | sed 's/^[ \t]*//;s/[ \t]*$//' )
	echo "Benchmark Results: $gbl" | tee -a $HOME/bench.log
	echo "Full report available at $HOME/bench.log" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
hlp () {
	echo ""
	echo "(C) Bench.sh 2 by Hidden Refuge <me at hiddenrefuge got eu dot org>"
	echo ""
	echo "Usage: bench.sh <option>"
	echo ""
	echo "Available options:"
	echo "No option	: System information, IPv4 only speedtest and disk speed & IOPing benchmark will be run."
	echo "-sys		: Displays system information such as CPU, amount CPU cores, RAM and more."
	echo "-io		: Runs a disk speed test and a IOPing benchmark and displays the results."
	echo "-iops		: Runs a extended IOPing test for latency, reading and et cetera."
	echo "-6		: Normal benchmark but with a IPv6 only speedtest (run when you have IPv6)."
	echo "-46		: Normal benchmark with IPv4 and IPv6 speedtest."
	echo "-64		: Same as above."
	echo "-b		: Normal benchmark with IPv4 only speedtest, I/O test and Geekbench system benchmark."
	echo "-b6		: Normal benchmark with IPv6 only speedtest, I/O test and Geekbench system benchmark."
	echo "-b46		: Normal benchmark with IPv4 and IPv6 speedtest, I/O test and Geekbench system benchmark."
	echo "-b64		: Same as above."
	echo "-h		: This help page."
	echo ""
	echo "The Geekbench system benchmark is experimental. So beware of failure!"
	echo ""
}
case $1 in
	'-sys')
		sysinfo;;
	'-io')
		iotest;;
	'-6' )
		sysinfo; speedtest6; iotest;;
	'-46' )
		sysinfo; speedtest4; speedtest6; iotest;;
	'-64' )
		sysinfo; speedtest4; speedtest6; iotest;;
	'-b' )
		sysinfo; speedtest4; iotest; gbench;;
	'-b6' )
		sysinfo; speedtest6; iotest; gbench;;
	'-b46' )
		sysinfo; speedtest4; speedtest6; iotest; gbench;;
	'-b64' )
		sysinfo; speedtest4; speedtest6; iotest; gbench;;
	'-h' )
		hlp;;
	*)
		sysinfo; speedtest4; iotest;;
esac
#################################################################################
# Contributors:									#
# thirthy_speed https://freevps.us/thread-16943-post-191398.html#pid191398 	#
#################################################################################
