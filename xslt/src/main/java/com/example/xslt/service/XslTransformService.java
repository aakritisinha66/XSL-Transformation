package com.example.xslt.service;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.StringWriter;

@Service
public class XslTransformService {

    public String transform() {
        try {
            Source xml = new StreamSource(new ClassPathResource("data/policy.xml").getInputStream());
            Source xsl = new StreamSource(new ClassPathResource("xslt/policy.xsl").getInputStream());

            TransformerFactory factory = TransformerFactory.newInstance();
            Transformer transformer = factory.newTransformer(xsl);

            StringWriter writer = new StringWriter();
            transformer.transform(xml, new StreamResult(writer));

            return writer.toString();
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }
}

