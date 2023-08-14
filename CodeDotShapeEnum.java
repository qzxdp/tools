package com.faea.qrcode.constants;

import com.beust.jcommander.internal.Lists;
import com.beust.jcommander.internal.Maps;
import com.faea.qrcode.model.CodeDotDrawModel;
import com.faea.qrcode.model.CodeDotPoint;

import java.awt.*;
import java.awt.geom.Path2D;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 二维码码点形状枚举
 *
 * @author liuchao
 * @date 2023/2/18
 */
public enum CodeDotShapeEnum {
    ROUND("round", "圆") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                graphics2D.fillOval(point.getRealX(), point.getRealY(), multiple, multiple);
            }

        }
    }, ROUND_MIN("round_min", "小圆") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            int offset = multiple / 5;
            int size = multiple - offset * 2;
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                graphics2D.fillOval(point.getRealX() + offset, point.getRealY() + offset, size, size);
            }

        }
    }, SQUARE("square", "方形") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            int offsetX = multiple / 8, offsetY = multiple / 8;
            int width = multiple - offsetX * 2, height = multiple - offsetY * 2;
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                graphics2D.fillRect(point.getRealX() + offsetX, point.getRealY() + offsetY, width, height);
            }

        }
    }, NORMAL("normal", "普通（默认）") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                graphics2D.fillRect(point.getRealX(), point.getRealY(), multiple, multiple);
            }

        }
    }, TRIANGLE("triangle", "三角形") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                int[] xPoints = {point.getRealX(), point.getRealX() + (multiple >> 1), point.getRealX() + multiple};
                int[] yPoints = {point.getRealY() + multiple, point.getRealY(), point.getRealY() + multiple};
                graphics2D.fillPolygon(xPoints, yPoints, 3);
            }
        }
    }, ROUNDED("rounded", "圆角矩形") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            int arc = multiple / 2;
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                graphics2D.fillRoundRect(point.getRealX(), point.getRealY(), multiple,
                        multiple, arc, arc);
            }
        }
    }, DIAMOND("diamond", "菱形") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            //x轴和y轴偏移量
            int offset = multiple / 10;
            // 由于上下左右都需要空出 一个偏移量，所以需要 宽度就需要 减去 两个偏移量
            int width = multiple - offset * 2, height = multiple - offset * 2;
            for (CodeDotPoint point : model.getCodeDotPointList()) {

                int x = point.getRealX() + offset;
                int y = point.getRealY() + offset;
                int[] xPoints = {x, x + width / 2, x + width, x + width / 2};
                int[] yPoints = {y + height / 2, y, y + height / 2, y + height};

                graphics2D.fillPolygon(xPoints, yPoints, 4);
            }
        }
    }, TRANSVERSE_STRIPE("transverse_stripe", "横向条纹") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            Map<String, CodeDotPoint> map = Maps.newHashMap();
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                String key = point.getInputY() + "-" + point.getInputX();
                map.put(key, point);
            }
            int multiple = model.getMultiple();
            int offset = multiple / 5;
            int h = multiple - 2 * offset;
            int arcWidth = h;
            int arcHeight = h;
            for (int i = 0; i < model.getCodeDotPointList().size(); i++) {
                CodeDotPoint point = model.getCodeDotPointList().get(i);
                int len = 1;
                for (int startX = point.getInputX() + 1; startX < model.getCodeWidth(); startX++) {
                    CodeDotPoint tempPoint = map.get(point.getInputY() + "-" + startX);
                    if (null == tempPoint) {
                        break;
                    }
                    len += 1;
                }
                if (len == 1) {
                    graphics2D.fillOval(point.getRealX() + offset, point.getRealY() + offset,
                            multiple - 2 * offset, multiple - 2 * offset);
                } else {
                    int w = multiple * len;
                    int x = point.getRealX();
                    int y = point.getRealY() + offset;
                    // 绘制带有圆角的矩形
                    graphics2D.fillRoundRect(x, y, w, h, arcWidth, arcHeight);

                }
                i += (len - 1);
            }

        }
    }, VERTICAL_STRIPE("vertical_stripe", "竖向条纹") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            Map<String, CodeDotPoint> map = Maps.newHashMap();
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                String key = point.getInputX() + "-" + point.getInputY();
                map.put(key, point);
            }
            int multiple = model.getMultiple();
            int offset = multiple / 5;
            int w = multiple - 2 * offset;
            int arcWidth = w;
            int arcHeight = w;
            //忽略的点
            List<String> ignorePoint = Lists.newArrayList();
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                String key = point.getInputX() + "-" + point.getInputY();
                if (ignorePoint.contains(key)) {
                    continue;
                }
                int len = 1;
                for (int startY = point.getInputY() + 1; startY < model.getCodeHeight(); startY++) {
                    key = point.getInputX() + "-" + startY;
                    if (!map.containsKey(key)) {
                        break;
                    }
                    len += 1;
                    ignorePoint.add(key);
                }
                if (len == 1) {
                    graphics2D.fillOval(point.getRealX() + offset, point.getRealY() + offset, multiple - offset * 2, multiple - offset * 2);
                } else {
                    int h = multiple * len;
                    int x = point.getRealX() + offset;
                    int y = point.getRealY();
                    // 绘制圆角矩形
                    graphics2D.fillRoundRect(x, y, w, h, arcWidth, arcHeight);
                }
            }
        }
    }, STAR("star", "星形") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            int multiple = model.getMultiple();
            int width = multiple, height = width;
            //圆弧的半径
            int radius = width / 2;
            for (CodeDotPoint point : model.getCodeDotPointList()) {
                int x = point.getRealX();
                int y = point.getRealY();
                Path2D path = new Path2D.Double();
                path.moveTo(x + radius, y);
                path.quadTo(x + radius, y + radius, x + width, y + radius);
                path.quadTo(x + radius, y + radius, x + radius, y + height);
                path.quadTo(x + radius, y + radius, x, y + radius);
                path.quadTo(x + radius, y + radius, x + radius, y);
                graphics2D.fill(path);
            }
        }
    }, CIRCULAR("circular", "圆形") {
        @Override
        public void draw(Graphics2D graphics2D, CodeDotDrawModel model) {
            double offset = 0.5;
            int multiple = model.getMultiple();
            double w = multiple - offset * 2;
            double h = w;

            double arc = multiple / 2;
            List<CodeDotPoint> codeDotPointList = model.getCodeDotPointList();
            //所有的坐标点
            List<String> allPointKeyList = codeDotPointList.stream().map(p -> p.getInputX() + "-" + p.getInputY()).collect(Collectors.toList());
            //需要忽略的点
            List<CodeDotPoint> ignorePoint = Lists.newArrayList();
            for (int i = 0; i < codeDotPointList.size(); i++) {
                CodeDotPoint point = codeDotPointList.get(i);
                double x = point.getRealX() + offset;
                double y = point.getRealY() + offset;
                String leftKey = (point.getInputX() - 1) + "-" + point.getInputY();
                String topKey = point.getInputX() + "-" + (point.getInputY() - 1);
                String rightKey = (point.getInputX() + 1) + "-" + point.getInputY();
                String bottomKey = point.getInputX() + "-" + (point.getInputY() + 1);
                // 左、右都有点
                if (allPointKeyList.contains(leftKey) && allPointKeyList.contains(rightKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y);
                    path.lineTo(x + w, y);
                    path.lineTo(x + w, y + h);
                    path.lineTo(x, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    // 上、下都有点
                } else if (allPointKeyList.contains(topKey) && allPointKeyList.contains(bottomKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y);
                    path.lineTo(x + w, y);
                    path.lineTo(x + w, y + h);
                    path.lineTo(x, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    // 右、下都有点
                } else if (allPointKeyList.contains(rightKey) && allPointKeyList.contains(bottomKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y + h);
                    path.quadTo(x, y, x + w, y);
                    path.lineTo(x + w, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    // 左、下都有点
                } else if (allPointKeyList.contains(leftKey) && allPointKeyList.contains(bottomKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y);
                    path.quadTo(x + w, y, x + w, y + h);
                    path.lineTo(x, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    // 上、右都有点
                } else if (allPointKeyList.contains(topKey) && allPointKeyList.contains(rightKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x + w, y);
                    path.lineTo(x + w, y + h);
                    path.quadTo(x, y + h, x, y);
                    path.closePath();
                    graphics2D.fill(path);
                    // 左、上都有点
                } else if (allPointKeyList.contains(leftKey) && allPointKeyList.contains(topKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y);
                    path.lineTo(x + w, y);
                    path.quadTo(x + w, y + h, x, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    // 上有点
                } else if (allPointKeyList.contains(topKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y);
                    path.lineTo(x + w, y);
                    path.lineTo(x + w, y + h - arc);
                    path.quadTo(x + w / 2, y + h, x, y + h - arc);
                    path.closePath();
                    graphics2D.fill(path);
                    // 下有点
                } else if (allPointKeyList.contains(bottomKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y + arc);
                    path.quadTo(x + w / 2, y, x + w, y + arc);
                    path.lineTo(x + w, y + h);
                    path.lineTo(x, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    // 左有点
                } else if (allPointKeyList.contains(leftKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x, y);
                    path.lineTo(x + w - arc, y);
                    path.quadTo(x + w, y + h / 2, x + w - arc, y + h);
                    path.lineTo(x, y + h);
                    path.closePath();
                    graphics2D.fill(path);
                    //右边有点
                } else if (allPointKeyList.contains(rightKey)) {
                    Path2D path = new Path2D.Double();
                    path.moveTo(x + w, y);
                    path.lineTo(x + w, y + h);
                    path.lineTo(x + arc, y + h);
                    path.quadTo(x, y + h / 2, x + arc, y);
                    path.closePath();
                    graphics2D.fill(path);
                } else {
                    graphics2D.fillOval(point.getRealX(), point.getRealY(), multiple, multiple);
                }
            }
        }
    };

    /**
     * 编码
     */
    private String code;

    private String desc;


    /**
     * 绘制码点
     *
     * @param graphics2D
     * @param model
     * @return void
     * @author liuchao
     * @date 2023/2/19
     */
    public abstract void draw(Graphics2D graphics2D, CodeDotDrawModel model);

    CodeDotShapeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    private static Map<String, CodeDotShapeEnum> codeMap = Maps.newHashMap();

    static {
        for (CodeDotShapeEnum e : CodeDotShapeEnum.values()) {
            codeMap.put(e.getCode(), e);
        }
    }

    public static CodeDotShapeEnum getByCode(String code) {
        return codeMap.get(code);
    }

}
