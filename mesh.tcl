set ns [new Simulator]

$ns color 1 green 
$ns color 2 red

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

$ns duplex-link $a $b 2Mb 10ms DropTail
$ns duplex-link $a $c 2Mb 10ms DropTail
$ns duplex-link $a $d 2Mb 10ms DropTail
$ns duplex-link $a $e 2Mb 10ms DropTail
$ns duplex-link $c $b 2Mb 10ms DropTail
$ns duplex-link $c $d 2Mb 10ms DropTail
$ns duplex-link $e $b 2Mb 10ms DropTail
$ns duplex-link $d $b 2Mb 10ms DropTail
$ns duplex-link $c $e 2Mb 10ms DropTail
$ns duplex-link $d $e 2Mb 10ms DropTail

#tcp
set tcp [new Agent/TCP]
$ns attach-agent $a $tcp
$tcp set fid_ 1
$tcp set class_ 1

#ftp
set ftp [new Application/FTP]
set maxpkts_ 500
$ftp attach-agent $tcp

#sink
set sink [new Agent/TCPSink]
$ns attach-agent $c $sink
$ns connect $tcp $sink

#udp
set udp [new Agent/UDP]
$ns attach-agent $b $udp
$udp set fid_ 2
$udp set class_ 2

#cbr
set cbr [new Application/Traffic/CBR]
$cbr set interval_ 0.005
$cbr set packetSize_ 1000
$cbr attach-agent $udp

#null
set null [new Agent/Null]
$ns attach-agent $d $null
$ns connect $udp $null

$ns at 1.0 "$cbr start"
$ns at 2.5 "$cbr stop"
$ns at 3.0 "$ftp start"
$ns at 5.0 "$ftp stop"

$ns at 5.0 "finish"

puts "cbr packet size =[$cbr set packet_size_]"

$ns run

