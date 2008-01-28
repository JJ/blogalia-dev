package Blogalia::Posteador;

use warnings;
use strict;
use Carp;

use version; 
our $VERSION = qw('0.0.1');

use lib qw ( .. ../lib ../.. lib);

# Other recommended modules (uncomment to use):
use YAML qw(Load LoadFile);
use XML::RPC;

# Module implementation here

sub new { #create new object of this class
  my ($class, $arg_ref) = @_;

  my $new_object;
  if ( ref $arg_ref ) { #argumentos en un hash
    $new_object = $arg_ref;
  } else { #Documento en YAML con los argumentos
    #Si lleva .yml o .yaml es que es un fichero
    if ( $arg_ref =~ /\.ya?ml/ ) {
      $new_object = LoadFile( $arg_ref )
    } else {
      $new_object = Load( $arg_ref );
    }
  }
  #Sustituye cadena por objeto
  $new_object->{'proxy'} = XML::RPC->new($new_object->{'proxy'}); 
  my $api_class = "Blogalia::Posteador::".$new_object->{'API'};
  eval " require $api_class " || croak "Can't find $api_class Module\n";
  $new_object->{'driver'} = $api_class->new() || croak "No puedo inicializar objeto\n";
  bless $new_object, $class;
  return $new_object;
}

# 
sub post { #Send story to blog
  my ($self, $historia ) =  @_;
  my $driver = $self->{'driver'};
  my $result = $driver->post( $self, $historia );
  return $result;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Blogalia::Posteador - Módulo para manejar una historia en Blogalia
desde el punto de vista del usuario, printipalmente


=head1 VERSION

This document describes Blogalia::Posteador version 0.0.1


=head1 SYNOPSIS

    use Blogalia::Posteador;

    #Desde XML
    my $historia_xml = <<EOH;
<historia>
<titulo>Historia de prueba</titulo>
<contenido>Contenido de la historia de prueba</contenido>
<trackbacks>http://un.uri http://otro.uri</trackbacks>
</historia>
EOH

   my $historia = Blogalia::Posteador->new( $historia_xml );

   #Desde un hash
   my $historia_hash= { titulo => 'Qué pasa',
                        contenido => 'Hasta ahí podíamos llegar',
                        trackbacks => 'http://un.uri http://otro.uri' };
   my $otra_historia = Blogalia::Posteador->new( $historia_hash );


  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=head2 new

   Crea un objeto nuevo desde un documento XML (más o menos) o desde
   un hash, como se explica en la sinopsis

=cut

=head2 post

   Envía una historia usando la configuración.

=cut

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
  
Blogalia::Historia requires no configuration files or environment variables.


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
C<bug-blogalia-historia@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

JJ Merelo  C<< <jj@merelo.net> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, JJ Merelo C<< <jj@merelo.net> >>. All rights reserved.

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
