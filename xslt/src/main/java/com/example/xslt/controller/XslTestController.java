package com.example.xslt.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.xslt.service.XslTransformService;

@RestController
public class XslTestController {

    private final XslTransformService service;

    public XslTestController(XslTransformService service) {
        this.service = service;
    }

    @GetMapping(value = "/test-xslt", produces = "text/html")
    public String test() {
        return service.transform();
    }
}

