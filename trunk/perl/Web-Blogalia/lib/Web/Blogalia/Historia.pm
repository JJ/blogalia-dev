package Blogalia;

=nead Synopsis

Para interaccionar con blogalia

=cut

use Net::Blogger;
use Frontier::Client;
use LWP::Simple qw(get);
use Carp;

our $dir = "directorio.php";

=head1 METHODS 

=head2 new

Procesa la historia y la mete en el filesystem

=cut 

sub new {
  my $class = shift;
  my $blogid = shift || croak "Don't have a blogid";
  my $username = shift || croak "Don't have an username";
  my $password = shift || croak "Don't have a password";
  my $b = Net::Blogger->new();
  $b->Username($username);
  $b->Password($password);
  $b->Proxy('http://www.blogalia.com/RPC.php');
  my $server = Frontier::Client->new(url => 'http://www.blogalia.com/RPC.php');
  my $self = { _blogger => $b,
	       _frontier => $server,
	       _blogid => $blogid};
  bless $self, $class;
  #Bitácoras de blogalia
  open( D, "<$dir" );
  my $dir = join("",<D>);
  close D;
  my @bitacoras = ($dir =~ m{<td><a href="http://([\w\-]+)\.blogalia.com/">}gs );
  $self->{_bitacoras} = \@bitacoras;
  return $self;
}

=head2 getPost

Se trae el post usando el blogger API

=cut

sub getPost {
  my $self = shift;
  my $historiaId = shift || croak "Dame el ID de la historia";
  # Call the remote server and get our result.
  my $b = $self->{_blogger};
  my $result = $b->getPost( $historiaId ) || croak $b->LastError();
  return $result;
}

=head2 getRecentPosts

Se trae los últimos posts usando el blogger API; por defecto se trae 10

=cut

sub getRecentPosts {
  my $self = shift;
  my $nPosts = shift || 10;
  # Call the remote server and get our result.
  my $b = $self->{_blogger};
  my $result = $b->getRecentPosts( {numposts => $nPosts} ) || croak $b->LastError();
  return $result;
}

=head2 traduce

Traduce del formato de plantillas blogalita a HTML

=cut
  
sub traduce {
  my $self = shift;
  my $toTranslate = shift;
  $toTranslate =~ s{\[\*([^\]]+)\*\]}{<b>$1</b>}gs; 
  $toTranslate =~ s{\[\/([^\]]+)\/\]}{<em>$1</em>}gs;
  $toTranslate =~ s{\[_([^\]]+)_\]}{<u>$1</u>}gs;
  $toTranslate =~ s{\[\{([^\]]+)\s+(\S+)\s*\}\]}{<a href='$2'>$1</a>}gs;
  return $toTranslate;
}

=head2 historias 

Se baja las historias, interpreta la página web y pone los IDs con título en un hash, que devuelve

=cut

sub historias {
  my $self = shift;
  my $blog = shift || "www";
  my $url =  "http://$blog.blogalia.com/historias/";
  my $historiasPag = get( $url ) || croak "No me he podido bajar $url";
  my %historias = ( $historiasPag =~ m{class="historiaListado"><a href="/historias/(\d+).*?">(.+?)</a>}gs );
  return %historias;
}

=head2 historiasCategoria

Se baja las historias, interpreta la página web y pone los IDs con título en un hash, que devuelve

=cut

sub historiasCategoria {
  my $self = shift;
  my $blog = shift || "www";
  my $categoria = shift || croak 'No existe la categoría\n';
  my $url =  "http://$blog.blogalia.com/categorias/$categoria";
  my $historiasPag = get( $url ) || croak "No me he podido bajar $url";
  my %historias = ( $historiasPag =~ m{class="historiaListado"><a href="/historias/(\d+).*?">(.+?)</a>}gs );
  return %historias;
}

=head2 bitacoras

Devuelve todas las bitácoras que hay en blogalia

=cut

sub bitacoras {
  my $self = shift;
  return @{$self->{_bitacoras}};

}
"Que es verdad, cohone!";
