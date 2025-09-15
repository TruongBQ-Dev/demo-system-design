import { ApiProperty } from '@nestjs/swagger';
import { AuthUserDto } from './auth-user.dto';

export class LoginResponseDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    description: 'JWT access token',
  })
  access_token: string;

  @ApiProperty({ type: AuthUserDto })
  user: AuthUserDto;

  @ApiProperty({ example: '7d' })
  expires_in: string;
}
