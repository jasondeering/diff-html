#!/usr/bin/env node

var fs = require('fs'),
	open = require('open'),
	git = require('gift'),
	_ = require('underscore');


var generatePrettyDiff = function ( parsedDiff ) {
	var template = fs.readFileSync( __dirname + "/template.html", "utf8" ),
		diffHtml = "";

		for ( var file in parsedDiff ) {
			diffHtml += "<h2>" + file + "</h2>" +
			"<div class='file-diff'><div>" +
				markUpDiff( parsedDiff[ file ] ) +
			"</div></div>";
		}

		var destFile = __dirname + "/tmp/diff.html";

		fs.writeFileSync( destFile, template.replace( "{{diff}}", diffHtml ) );
		open( destFile );
}

var markUpDiff = function() {
	var diffClasses = {
		"d": "file",
		"i": "file",
		"@": "info",
		"-": "delete",
		"+": "insert",
		" ": "context"
	};

	function escape( str ) {
		return str
			.replace( /&/g, "&amp;" )
			.replace( /</g, "&lt;" )
			.replace( />/g, "&gt;" )
			.replace( /\t/g, "    " );
	}

	return function( diff ) {
		return diff.map(function( line ) {
			var type = line.charAt( 0 );
			return "<pre class='" + diffClasses[ type ] + "'>" + escape( line ) + "</pre>";
		}).join( "\n" );
	};
}();

module.exports = function() {
	var template = fs.readFileSync( __dirname + "/template.html", "utf8" );

	var repo = git(process.cwd());

	console.log("repo: "+repo.path);

	repo.commits(function(err, commits){

		_.each(commits, function(commit){

			var parent = _.first(commit.parents());
			console.log(commit);
			console.log(parent);

		});

	});

};