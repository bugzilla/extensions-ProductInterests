# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is the ProductInterests GNOME Bugzilla Extension.
#
# The Initial Developer of the Original Code is Olav Vitters
# Portions created by the Initial Developer are Copyright (C) 2011 the
# Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Olav Vitters <olav@vitters.nl>

package Bugzilla::Extension::ProductInterests;
use strict;
use base qw(Bugzilla::Extension);

our $VERSION = '0.01';

BEGIN {
        *Bugzilla::User::product_interests = \&product_interests;
}


sub product_interests {
    my $self = shift;

    return $self->{'product_int'} if defined $self->{'product_int'};
    return [] unless $self->id;

    my $product_ids = Bugzilla->dbh->selectcol_arrayref(
        qq{SELECT products.id
             FROM components
       INNER JOIN products
               ON components.product_id = products.id
        LEFT JOIN watch
               ON components.initialowner = watch.watched
            WHERE products.isactive = '1'
              AND (watch.watcher = ? OR components.initialowner = ?)
         ORDER BY products.name}, 
    undef, ($self->id, $self->id));

    $self->{'product_int'} = Bugzilla::Product->new_from_list($product_ids);

    return $self->{'product_int'};
}


__PACKAGE__->NAME;
