<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="tomain"/>
		<title>Welcome to Grails</title>
	</head>
	<body>
		<ul>
			<li>
				<a href="${createLink(controller:'question', action:'list')}">Question list</a>
			</li>
			<li>
				<a href="${createLink(controller:'question', action:'createQuestionFromBiocache')}">Create a question from an biocache occurrence Id</a>
			</li>
			<li>
				<a href="${createLink(controller:'question', action:'createQuestionFromEcodata')}">Create a question from an ecodata occurrence Id</a>
			</li>
		</ul>
	</body>
</html>
