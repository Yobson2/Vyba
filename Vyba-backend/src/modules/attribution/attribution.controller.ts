import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AttributionService } from './attribution.service';
import { CaptureLandingDto } from './dto/capture-landing.dto';
import { Public } from '@common/decorators/public.decorator';

@ApiTags('Attribution')
@Controller('api/attribution')
export class AttributionController {
  constructor(private readonly attributionService: AttributionService) {}

  @Post('landing')
  @Public()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary:
      'Record a raw landing (QR scan, promoter link, social campaign open) — pre-signup, no auth',
  })
  @ApiResponse({ status: 201, description: 'Landing recorded' })
  captureLanding(@Body() dto: CaptureLandingDto) {
    return this.attributionService.captureLanding(dto);
  }
}
