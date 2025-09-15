import {
  IsEmail,
  IsString,
  IsOptional,
  IsBoolean,
  MinLength,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ example: 'john@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'John Doe', required: false })
  @IsOptional()
  @IsString()
  name?: string;

  @ApiProperty({ example: 'password123', minLength: 6 })
  @IsString()
  @MinLength(6)
  password: string;

  @ApiProperty({
    example: true,
    required: false,
    description: 'User active status',
  })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
