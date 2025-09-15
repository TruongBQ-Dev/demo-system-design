import { IsString, IsOptional, IsBoolean, IsInt } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreatePostDto {
  @ApiProperty({ example: 'My First Post' })
  @IsString()
  title: string;

  @ApiProperty({
    example: 'This is the content of my first post',
    required: false,
  })
  @IsOptional()
  @IsString()
  content?: string;

  @ApiProperty({ example: false, required: false })
  @IsOptional()
  @IsBoolean()
  published?: boolean;

  @ApiProperty({ example: 1 })
  @IsInt()
  authorId: number;
}
