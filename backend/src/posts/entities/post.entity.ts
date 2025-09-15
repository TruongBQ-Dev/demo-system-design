import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';

export class Post {
  @ApiProperty()
  id: number;

  @ApiProperty()
  title: string;

  @ApiProperty()
  content: string;

  @ApiProperty()
  published: boolean;

  @ApiProperty()
  authorId: number;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;

  @ApiProperty()
  author?: User;
}
