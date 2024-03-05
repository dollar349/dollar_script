#!/bin/python3

import sys
from PIL import Image, ImageDraw, ImageFont

font_size = 12
line_spacing = -2

if len(sys.argv) != 2:
    print("Please give a text file!!!")
    sys.exit(1)

input_file = sys.argv[1]
input_file_name = input_file.rsplit('.', 1)[0]
output_image_path = f'{input_file_name}.png'


def calculate_line_and_max_length(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

        # 計算行數
        line_count = len(lines)

        # 計算每行中的最大文字數量
        max_line_length = max(len(line) for line in lines)

    return line_count, max_line_length


def text_to_image(input_text, output_image_path, font_size=12, image_size=(800, 600), font_path=None, line_spacing=-2):
    # 创建一个空白图像
    image = Image.new('RGB', image_size, color='white')
    draw = ImageDraw.Draw(image)

    # 选择字体
    font = ImageFont.truetype("mingliu.ttc", font_size)

    # 设置文本和位置
    text = "\n".join(input_text)
    text_position = (10, 10)

    # 将文本绘制到图像上
    draw.multiline_text(text_position, text, font=font, fill='black', spacing=line_spacing)

    # 保存图像
    image.save(output_image_path)

# 读取文本文件
line_count, max_line_length = calculate_line_and_max_length(input_file)
# print(f'行數: {line_count}')
# print(f'每行最大文字數量: {max_line_length}')

with open(input_file, 'r') as file:
    text_content = file.readlines()

# 将文本转换为图像
text_to_image(text_content, output_image_path, font_size, (max_line_length*8, line_count*21), line_spacing)
