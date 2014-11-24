<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title>Welcome to Grails</title>
		<style type="text/css" media="screen">

		</style>
	</head>
	<body class="content">
		<ul>
			<li>
				<a href="${createLink(controller:'question', action:'list')}">Question list</a>
			</li>
			<li>
				<a href="${createLink(controller:'question', action:'createQuestion')}">Create a question from an occurrence Id</a>
			</li>

		</ul>
	</body>
</html>
