package au.org.ala.taxonoverflow

import com.github.rjeschke.txtmark.Processor

class MarkdownService {


    public synchronized String markdown(String source) {
        return Processor.process(source)
    }

}
