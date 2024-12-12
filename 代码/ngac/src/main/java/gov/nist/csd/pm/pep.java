package gov.nist.csd.pm;

import gov.nist.csd.pm.pap.PAP;
import gov.nist.csd.pm.pap.memory.MemoryPAP;
import gov.nist.csd.pm.pdp.PDP;
import gov.nist.csd.pm.pdp.memory.MemoryPDP;
import gov.nist.csd.pm.policy.exceptions.PMException;
import gov.nist.csd.pm.policy.model.access.UserContext;
import gov.nist.csd.pm.policy.serializer.PALDeserializer;
import org.apache.commons.io.IOUtils;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.io.File;
import static gov.nist.csd.pm.pap.SuperPolicy.SUPER_USER;
public class pep {
  public static void main (String[] args) throws PMException, IOException {
    PAP pap = new MemoryPAP();
    UserContext superUser = new UserContext(SUPER_USER);
    File file = new File("pal/1.pal");/*文件名*/
    pap.fromString(txt2String(file), new PALDeserializer(new UserContext(SUPER_USER)));
//    System.out.println(pap.graph().nodeExists("helloworld"));
//    System.out.println(pap.graph().getPolicyClasses());

    PDP pdp = new MemoryPDP(pap);
    pdp.runTx(superUser, (policy) -> {
      policy.graph().createPolicyClass("pc3");
      policy.graph().createObjectAttribute("oa3", "pc3");
      policy.graph().assign("o1", "oa3");
    });

    UserContext u1 = new UserContext("u1");
    pdp.runTx(u1, (policy) -> {
      policy.graph().createObjectAttribute("newOA", "oa1");
    });

  }
  public static String txt2String(File file){
    StringBuilder result = new StringBuilder();
    try{
      BufferedReader br = new BufferedReader(new FileReader(file));//构造一个BufferedReader类来读取文件
      String s = null;
      while((s = br.readLine())!=null){//使用readLine方法，一次读一行
        result.append(System.lineSeparator()+s);
      }
      br.close();
    }catch(Exception e){
      e.printStackTrace();
    }
    return result.toString();
  }
}
