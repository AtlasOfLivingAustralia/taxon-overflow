<g:applyLayout name="main">
    <head>
        <title><g:layoutTitle/></title>
    </head>
    <body>
        <g:layoutBody/>
    </body>
    <r:script>
        tolib.keepSessionAliveUrl = '${g.createLink(uri: '/ping')}';
    </r:script>
</g:applyLayout>