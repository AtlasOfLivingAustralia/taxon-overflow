package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.User

class UserJSONMarshaller extends AbstractJSONMarshaller<User> {

    @Override
    protected void marshalObject(User user, Map result) {
        result.id = user.id
        result.alaUserId = user.alaUserId
    }

    @Override
    protected Class<User> getWrappedClass() {
        return User.class
    }

}
