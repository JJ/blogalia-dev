package Web::Blogalia::Comentarios;

use strict;
use warnings;

use LWP::UserAgent;
use File::Slurp;

use Exporter;
our @ISA = ('Exporter');

our $dir = "/var/tmp/comentarios";

=head2 new

=item

Comprueba si el fichero de comentarios estÃ¡ presente, y lo analiza

=cut

sub new {
  
  my $class = shift;
  my $site = shift || 'blogalia';

  my $ua = LWP::UserAgent->new;
  $ua->agent("Araña atalayera 0.02 ");
  my $timeOut = 400;
  if ( !-e $dir ) {
    mkdir $dir
  }
  my $fn = "$dir/$site.100comentarios.html";

  #Existe el fichero?
  my $lastTime = 0;
  my $thisTime = time;
  if ( -e $fn ) {
    my (@cosas ) = stat( $fn );
    $lastTime = $cosas[$#cosas-3];
  }
  
  my $ultimosComentarios;
  if ( ($thisTime - $lastTime) > $timeOut ) {
    my $url= "http://www.$site.com/100comentarios.php";
    my $response = $ua->get( $url ) || die "No puedo bajarme los comentarios";
    $ultimosComentarios = $response->content() ;
    open( F, ">$fn" ) || die "La cagamos: no se puede abrir $fn";
    print F $ultimosComentarios;
    close F;
  } else {
    $ultimosComentarios = read_file($fn);
  }
  

  my ( @comentarios ) = 
    ( $ultimosComentarios =~ 
      m{<tr class="\w+" valign="top">\s+<td nowrap>(.*?)\s+<td nowrap><a href="(\S+)">(.+?)</a></td>\s+<td nowrap>.+?</td>}gs );
  
  
  my %commentsHash;
  while ( @comentarios ) {
    my $autor = shift @comentarios;
    my $comURL = shift @comentarios;
    my $historia = shift @comentarios;
    my ($thisURL) = ( $comURL =~ /(\S+)\#(\d+)/);
    push( @{$commentsHash{$thisURL}}, [$autor, $comURL, $historia] );
  }
  my $self = \%commentsHash;
  bless $self, $class;
  return $self;
}


=head2 by_blog

=item

Devuelve el número de comentarios por blog

=cut

sub by_blog {
  my $self = shift;
  my %comments_by_blog;
  for my $u ( keys %$self ) {
    my ($blog) = ( $u =~ m{http://([^\.]+)\.} );
    $comments_by_blog{$blog}+= scalar( @{$self->{$u}} );
  }
  return \%comments_by_blog;

}
