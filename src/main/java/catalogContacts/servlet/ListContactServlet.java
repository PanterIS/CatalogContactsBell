package catalogContacts.servlet;

import catalogContacts.controller.ControllerHTML;
import catalogContacts.dao.exception.DaoException;
import catalogContacts.service.ContactService;
import catalogContacts.service.UserService;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 */
@Controller
public class ListContactServlet extends HttpServlet {
    ControllerHTML controllerHTML;
    UserService userService;
    ContactService contactService;
    private static Logger logger=Logger.getLogger(DataContactServlet.class.getName());

    @Override
    @RequestMapping(value = "/contacts", method = RequestMethod.GET)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    @RequestMapping(value = "/contacts", method = RequestMethod.POST)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");

        PrintWriter out = response.getWriter();
        String iduserStr = request.getParameter("iduser");
        if (iduserStr == null) {
            logger.error("Ошибка авторизации");
            out.println("Ошибка авторизации");
            return;
        }
        String buttonAction = request.getParameter("buttonaction");
        try {

            synchronized (this) {
               userService.setUserThread(Integer.parseInt(iduserStr));
                if (buttonAction != null) {
                    out.println(selectingTheActionForTheButton(buttonAction, request, response));
                } else {

                 out.println(controllerHTML.showContactListStr(null));
                }
            }
        } catch (DaoException e) {
            out.println("Ошибка получения данных");
        }catch (Exception e) {
            logger.error("Ошибка " + e.getMessage());
            out.println("Ошибка данных");
        }
    }

    private String selectingTheActionForTheButton(String buttonAction, HttpServletRequest request, HttpServletResponse response) throws DaoException, NumberFormatException, IOException {

            switch (buttonAction) {
                case "add":
                   contactService.addContact(request.getParameter("namecontact"));
                    return controllerHTML.showContactListStr(null);
                case "delete":
                    contactService.deleteContact(Integer.parseInt(request.getParameter("idcontact")));
                    return controllerHTML.showContactListStr(null);
                case "searchForContacts":
                    return controllerHTML.findByName(request.getParameter("searchnamecontact"));
            }

        return "";
    }

    public void setControllerHTML(ControllerHTML controllerHTML) {
        this.controllerHTML = controllerHTML;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setContactService(ContactService contactService) {
        this.contactService = contactService;
    }
}
