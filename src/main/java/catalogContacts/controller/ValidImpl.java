package catalogContacts.controller;

import catalogContacts.TypeContact;

/**
 * Created by iren on 16.07.2017.
 */
public class ValidImpl implements Valid{
    public int actionValid(String strReader) {
        int selectedAction =-1;
        try {
            selectedAction = Integer.parseInt(strReader);
        } catch (Exception e) {
            return -1;
        }
        return selectedAction;
    }

    public Boolean valueContactDetailsValid(TypeContact type) {
        return null;
    }
}
