<g:applyLayout name="main">
    <body>
        <g:layoutBody/>
    </body>
    <r:script>
        tolib.keepSessionAliveUrl = '${g.createLink(uri: '/ping')}';
    </r:script>
</g:applyLayout>