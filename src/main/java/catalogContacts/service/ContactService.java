package catalogContacts.service;

import catalogContacts.dao.CrudDAO;
import catalogContacts.dao.exception.DaoException;
import catalogContacts.model.Contact;
import catalogContacts.model.ContactDetails;
import catalogContacts.model.Group;
import catalogContacts.model.TypeContact;

import java.util.List;
import java.util.Map;

/**
 * Created by iren on 16.07.2017.
 */
public interface ContactService {

    void addContact(String name) throws DaoException;
    void addContactDetails(int numberContact,Map<TypeContact,String> mapDetails) throws DaoException;
    void saveContact(Contact contact) throws DaoException;
    void deleteContact(int numberContact) throws DaoException;
    void deleteContactDetails(int numberContact,int numberContactDetails) throws DaoException;
    void ChangeSelectedContactDetails(int numberContact,int numberContactDetails,String value) throws DaoException;
    List<Contact> showContactList(Integer numberGroup) throws DaoException;
    List<ContactDetails> showContactDetails(int numberContact) throws DaoException;
    Contact getContactByNumber(int numberContact) throws DaoException;
    void changeContact(int numberContact,String value) throws DaoException;
    void addGroupToContact(int numberContact, int numberGroup) throws DaoException;
    void deleteGroupToContact(int numberContact, int numberGroup) throws DaoException;
    void setCrudDAOContact(CrudDAO<Contact> crudDAO);
    void setCrudDAOGroup(CrudDAO<Group> crudDAOGroup);
    List<Contact> findByName(String name) throws DaoException;

}
