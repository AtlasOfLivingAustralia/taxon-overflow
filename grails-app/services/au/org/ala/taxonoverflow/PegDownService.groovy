package au.org.ala.taxonoverflow

import org.pegdown.PegDownProcessor

class PegDownService {

    PegDownProcessor pegDownProcessor = new PegDownProcessor()

    public synchronized String markdown(String source) {
        return pegDownProcessor.markdownToHtml(source)
    }

}
