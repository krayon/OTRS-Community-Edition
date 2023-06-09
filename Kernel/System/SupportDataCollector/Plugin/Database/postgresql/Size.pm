# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2023 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::Size;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') !~ m{^postgresql} ) {
        return $Self->GetResults();
    }

    # version check
    $DBObject->Prepare(
        SQL   => "SELECT pg_size_pretty(pg_database_size(current_database()))",
        LIMIT => 1,
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if ( $Row[0] ) {
            $Self->AddResultInformation(
                Label => Translatable('Database Size'),
                Value => $Row[0],
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => Translatable('Database Size'),
                Value   => $Row[0],
                Message => Translatable('Could not determine database size.')
            );
        }
    }

    return $Self->GetResults();
}

1;
