set ns [new Simulator]
$ns color 1 Red

set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf    
    exec nam out.nam &
    exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n1 2mb 10ms DropTail
$ns duplex-link $n0 $n2 2mb 10ms DropTail
$ns duplex-link $n0 $n3 2mb 10ms DropTail
$ns duplex-link $n0 $n4 2mb 10ms DropTail


$ns duplex-link-op $n0 $n1 orient right-down 
$ns duplex-link-op $n0 $n2 orient left-down 
$ns duplex-link-op $n0 $n3 orient right-up 
$ns duplex-link-op $n0 $n4 orient left-up

set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP


$ns at 0.1 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 5.0 "finish"
$ns run
