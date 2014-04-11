#!/usr/bin/perl

use strict;
use warnings;

use File::Slurp qw(slurp write_file);
use WWW::Bizowie::API;
use File::ChangeNotify;

my ($file, $template_id) = @ARGV;

die "Bad file" unless -e $file;

my @stat  = stat($file);
my $mtime = $stat[9];

my $bizowie = WWW::Bizowie::API->new(
    api_key    => $ENV{BZ_API_KEY},
    secret_key => $ENV{BZ_SECRET_KEY},
    site       => $ENV{BZ_HOST},
);

my $r = $bizowie->call('/correspondence/template', {
    correspondence_template_id => $template_id,
});

die "Can't talk to Bizowie!" unless $r->success;

my $template = $r->data->{template}{template};
write_file($file, $template);

print "Generated a working file at $file\n";

while(1)
{
    my @new_stat  = stat($file);
    my $new_mtime = $new_stat[9];
    if ($new_mtime != $mtime)
    {
        $mtime = $new_mtime;

        my $new_file = slurp($file);

        print "Writing new template";
        $bizowie->call('/correspondence/template', {
            correspondence_template_id => 1,
            template                   => $new_file,
        });
    }
    sleep 1;
}

