#!/usr/bin/perl

use strict;
use warnings;
use XML::LibXML;

if ($#ARGV < 0) {
	print "Usage:\n\t$0 path_to_qcadoo_model_xml [path_to_another_model [yet_another [..]]]\n";
	exit;
} else {
	for my $xml (@ARGV) {
		parseModel($xml);
	}
}

sub parseModel {
	my $xml = XML::LibXML->load_xml( location => $_[0]);
	my $xpc = XML::LibXML::XPathContext->new($xml);
	$xpc->registerNs("model", "http://schema.qcadoo.org/model");
	my $className = ucfirst($xpc->findvalue("/model:model/\@name"));

	print "public final class $className {\n";
	print "\n\tprivate $className() {}\n\n";
	foreach my $field ($xpc->findnodes("/model:model/model:fields/*")) {
		my $modelFieldName = $field->findvalue("\@name");
		print "\tpublic static final String ", camelToUnderscore($modelFieldName), " = \"$modelFieldName\";\n\n";
	}
	print "}\n\n";
}

sub camelToUnderscore {
	$_ = lcfirst($_[0]);
	s/(\p{Uppercase})/_$1/g;
	return uc($_);
}

