package com.camping.life.common;

/**
 * 业务异常
 */
public class BizException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private Integer code = 500;
    private String msg;

    public BizException(String msg) {
        super(msg);
        this.msg = msg;
    }

    public BizException(Integer code, String msg) {
        super(msg);
        this.code = code;
        this.msg = msg;
    }

    public BizException(String msg, Throwable cause) {
        super(msg, cause);
        this.msg = msg;
    }

    public Integer getCode() { return code; }
    public String getMsg() { return msg; }
}
