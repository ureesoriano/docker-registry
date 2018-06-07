package Docker::Registry::Gitlab;
use Moose;
extends 'Docker::Registry::V2';
use namespace::autoclean;

# ABSTRACT: Be able to talk to the gitlab registry

use Docker::Registry::Types qw(DockerRegistryURI);

has '+url' => (
    lazy    => 1,
    default => sub {
        my $self = shift;
        'https://registry.gitlab.com';
    }
);

has 'username' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'password' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'jwt' => (
    is        => 'ro',
    isa       => DockerRegistryURI,
    predicate => 'has_jwt',
);

has 'repo' => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_repo',
);

has '+auth' => (
    lazy    => 1,
    default => sub {
        my $self = shift;
        return Docker::Registry::Auth::Gitlab->new(
            username => $self->username,
            password => $self->password,
            $self->has_jwt ? ( jwt => $self->jwt ) : (),
            $self->has_repo ? ( repo => $self->repo ) : (),
        );
    },
);

around 'repositories' => sub {
    my $orig = shift;
    my $self = shift;

    if ($ENV{GITLAB_SCOPE}) {
        $self->$orig(@_);
    }
    else {
        ...;
    }
};

__PACKAGE__->meta->make_immutable;

__END__

=head1 DESCRIPTION

Connect and do things with the gitlab registry

=head1 SYNOPSIS

    use Docker::Registry::Gitlab;
    my $registry = Docker::Registry::Gitlab->new(
        username => 'foo',
        password => 'bar', # your private token at gitlab
    );

=head1 ATTRIBUTES

=head2 url

The endpoint of the registry, defaults to 'https://registry.gitlab.com'.

=head2 username

Your username at gitlab

=head2 password

The access token you get from
L<gitlab|https://gitlab.com/profile/personal_access_tokens> with
'read_registry' access.

=head2 repo

The repository you want to query.

=head2 jwt

The endpoint to request the JWT token from, if none supplied the default
of L<Docker::Registry::Auth::Gitlab> will be used.

=head1 METHODS

=head2 repositories

Unimplemented code path unless GITLAB_SCOPE is set as an environment variable.

=head1 BUGS

Because Gitlab doesn't support wild cards in scopes (yet!), you are not
able to call certain functions. L<Docker::Registry::Gitlab/repositories>
being one of them. For more information see:
L<https://gitlab.com/gitlab-org/gitlab-ce/issues/47497>

=head1 SEE ALSO

L<Docker::Registry::Auth::Gitlab> and L<Docker::Registry::V2>.
