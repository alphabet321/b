set ns [new Simulator]

$ns color 1 red 
$ns color 2 blue

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}

set a [$ns node]
set b [$ns node]
set c [$ns node]
set d [$ns node]
set e [$ns node]

$ns simplex-link $a $b 2Mb 10ms DropTail
$ns simplex-link $b $d 2Mb 10ms DropTail
$ns simplex-link $d $e 2Mb 10ms DropTail
$ns simplex-link $e $c 2Mb 10ms DropTail
$ns simplex-link $c $a 2Mb 10ms DropTail

#tcp
set tcp [new Agent/TCP]
$ns attach-agent $a $tcp
$tcp set fid_ 1
$tcp set class_ 1

#ftp 
set ftp [new Application/FTP]
set maxpkts_ 1000
$ftp attach-agent $tcp

#sink
set sink [new Agent /TCPSink]
$ns attach-agent $c $sink
$ns connect $tcp $sink

#udp
set udp [new Agent/UDP]
$ns attach-agent $d $udp
$udp set fid_ 2
$udp set class_ 2

#cbr
set cbr [new Application/Traffic/CBR]
$cbr set interval_ 0.005
$cbr set packetSize_ 1000
$cbr attach-agent $udp

#null
set null [new Agent/Null]
$ns attach-agent $e $null
$ns connect $udp $null

$ns at 1.0 "$cbr start"
$ns at 3.0 "$cbr stop"
$ns at 4.0 "$ftp start"
$ns at 5.0 "$ftp stop"

$ns at 5.0 "finish"

puts "cbr packet size=[$cbr set packet_size_]"

$ns run

