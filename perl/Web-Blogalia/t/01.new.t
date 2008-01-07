use Test::More tests => 3; #

use YAML qw(LoadFile);
use Web::Blogalia;

diag( "Testing Web::Blogalia $Web::Blogalia::VERSION" );
my $blogalia = Web::Blogalia->new() ; # Para Blogalia
ok( $blogalia->{'site'} eq 'blogalia', 'Valores por defecto OK' );
my $conf_file = 'exampleconf.yaml';
if ( !-e $conf_file ) {
  $conf_file = 't/exampleconf.yaml';
}
my $otra_blogalia = Web::Blogalia->new( $conf_file ); # Para valores especiales
ok( $otra_blogalia->{'site'} eq 'bloxus', 'Desde fichero OK' );
my $conf = LoadFile( $conf_file );
$otra_blogalia = Web::Blogalia->new( $conf ); # Para valores especiales
ok( $otra_blogalia->{'tmpdir'} eq '/var/tmp/bloxus', 'Desde var OK' );
