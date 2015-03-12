package au.org.ala.taxonoverflow

public class ServiceResult<T> {

    public boolean success
    public List<String> messages = []
    public T result

    def asBoolean() {
        return success
    }

    def success(T result) {
        this.result = result
        success = true
    }

    def success(T result, messages) {
        this.result = result
        this.messages = messages
        success = true
    }

    def fail(String message) {
        success = false
        messages << message
        return this
    }

    def getCombinedMessages(String delim = ". ") {
        return messages?.join(delim)
    }

    public T get() {
        return result
    }

}
