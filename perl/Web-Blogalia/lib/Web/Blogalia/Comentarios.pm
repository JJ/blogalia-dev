package Web::Blogalia::Comentarios;

use strict;
use warnings;
use Carp;

use version; our $VERSION = qv('0.0.3');

use LWP::UserAgent;
use File::Slurp;


use Exporter;
our @ISA = ('Exporter');


use Web::Blogalia;

=head2 new

=item

Comprueba si el fichero de comentarios estÃ¡ presente, y lo analiza

=cut

sub new {
  
  my $class = shift;
  my $blogalia = shift || Web::Blogalia->new(); # Por defecto posiblemente va bien

  my $ua = LWP::UserAgent->new;
  $ua->agent("Araña atalayera 0.02 ");
  my $timeOut = 400;

  my $dir = $blogalia->{'tmpdir'};
  if ( !-e $dir ) {
    mkdir $dir;
  }
  my $site = $blogalia->{'site'};
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
    open my $f, ">", $fn or croak "La cagamos: no se puede abrir $fn";
    print $f $ultimosComentarios;
    close $f;
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

1; # Magic true value required at end of module
__END__

=head1 NAME

Web::Blogalia::Comentarios - Para tratar los comentarios de Blogalia.


=head1 VERSION

This document describes Web::Blogalia::Comentarios version 0.0.1


=head1 SYNOPSIS

    use Web::Blogalia;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Web::Blogalia requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-web-blogalia@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
