package com.taramtech.taram_event.utils;

import lombok.Data;

@Data
public class PagingRequest {
    private int page;
    private int size;

    public PagingRequest() {
        this.page = 1;
        this.size = 20;
    }

    public PagingRequest(int page) {
        this.page = page;
        size = 20;
    }

    public PagingRequest(int page, int size) {
        this.page = page;
        this.size = size;
    }
}
