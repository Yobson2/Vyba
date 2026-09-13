import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PaginationQueryDto } from '@common/dto/pagination.dto';
import { Roles } from '@common/decorators/roles.decorator';
import { RolesGuard } from '@common/guards/roles.guard';
import { UserRole } from '@common/constants/roles.constant';

/**
 * Admin-only surface (dashboard "Users" screen). Every route requires
 * ADMIN — these expose phone numbers and acquisition PII for every account,
 * never meant for a client/venue-owner's own-profile access (no mobile
 * caller uses this controller; self-profile is a separate concern).
 */
@ApiTags('Users')
@ApiBearerAuth('JWT-auth')
@Controller('api/users')
@UseGuards(RolesGuard)
@Roles(UserRole.ADMIN)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({
    summary: 'Provision a user by phone (admin only, e.g. a venue owner)',
  })
  @ApiResponse({ status: 201, description: 'User created successfully' })
  @ApiResponse({ status: 409, description: 'User already exists' })
  create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto);
  }

  @Get()
  @ApiOperation({ summary: 'List all users (paginated, admin only)' })
  @ApiResponse({ status: 200, description: 'Paginated user list' })
  findAll(@Query() query: PaginationQueryDto) {
    return this.usersService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID (admin only)' })
  @ApiResponse({ status: 200, description: 'User found' })
  @ApiResponse({ status: 404, description: 'User not found' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update user (admin only)' })
  @ApiResponse({ status: 200, description: 'User updated' })
  update(@Param('id') id: string, @Body() dto: UpdateUserDto) {
    return this.usersService.update(id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Deactivate user (admin only)' })
  @ApiResponse({ status: 200, description: 'User deactivated' })
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
